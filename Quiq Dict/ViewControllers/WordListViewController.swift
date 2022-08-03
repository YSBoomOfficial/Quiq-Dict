//
//  ViewController.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import UIKit
import Combine

class WordListViewController: UIViewController {
	private let searchController = UISearchController(searchResultsController: nil)
	private let tableView = UITableView(frame: .zero, style: .insetGrouped)

	private(set) var wordViewModels = [WordViewModel]()

	var service: WordsService?

	private(set) var searchTerm = ""

	var cancellable = [AnyCancellable]()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Quiq Dict"

		setupTableView()
		setupSearchController()
		debounceSearchBarTextField()
	}
}

// MARK: View Setup
extension WordListViewController {
	private func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(WordCell.self, forCellReuseIdentifier: WordCell.reuseID)
		tableView.dataSource = self
		tableView.delegate = self

		tableView.refreshControl = .init()
		tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
	}

	private func setupSearchController() {
		searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
		searchController.searchBar.placeholder = "Search for a word..."
		searchController.obscuresBackgroundDuringPresentation = false
		//		searchController.searchBar.delegate = self
		searchController.searchBar.keyboardType = .default

		navigationController?.navigationBar.barTintColor = .systemBackground
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = true
	}
}

// MARK: UITableViewControllerDataSource & UITableViewControllerDelegate
extension WordListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		wordViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: WordCell.reuseID, for: indexPath) as? WordCell else {
			fatalError("cast to WordCell failed")
		}
		cell.configure(with: wordViewModels[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
}

// MARK: Actions
extension WordListViewController {
	private func handleAPIResult(_ result: Result<[WordViewModel], Error>) {
		DispatchQueue.mainAsyncIfNeeded { [weak self] in
			self?.tableView.refreshControl?.endRefreshing()
			switch result {
				case .success(let wordVMs):
					self?.wordViewModels = wordVMs
					self?.tableView.reloadSections(.init(integer: 0), with: .automatic)
				case .failure(let error):
					self?.show(error: error)
			}
		}
	}

	@objc private func refresh() {
		DispatchQueue.mainAsyncIfNeeded { [weak self] in
			self?.tableView.refreshControl?.beginRefreshing()
		}
		service?.loadDefinitions(for: searchTerm, completion: handleAPIResult)
	}

	func debounceSearchBarTextField() {
		NotificationCenter.default.publisher(
			for: UISearchTextField.textDidChangeNotification,
			object: searchController.searchBar.searchTextField
		)
		.map { ($0.object as! UISearchTextField).text }
		.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
		.sink { value in
			DispatchQueue.global(qos: .userInitiated).async { [weak self] in
				if let text = value, !text.isEmpty {
					self?.searchTerm = text
					self?.refresh()
				}
			}
		}
		.store(in: &cancellable)
	}
}
