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

	private(set) var words = [Word]() {
		didSet {
			tableView.reloadSections(.init(integer: 0), with: .automatic)
		}
	}

	private let searchAction: (String, @escaping (Result<[Word], NetworkError>) -> Void) -> Void
	private let didSelectWord: (Word) -> UIViewController
	private let onSave: (Word) -> Void
	private let onDelete: (Word) -> Void

	private var searchTerm = ""
	private var cancellable: AnyCancellable?
	private(set) var isRefreshing = false {
		didSet {
			DispatchQueue.main.async { [weak self] in
				guard let self else { return }
				if self.isRefreshing {
					self.tableView.refreshControl?.beginRefreshing()
				} else {
					self.tableView.refreshControl?.endRefreshing()
				}
			}
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	init(
		words: [Word],
		searchAction: @escaping (String, @escaping (Result<[Word], NetworkError>) -> Void) -> Void,
		didSelectWord: @escaping (Word) -> UIViewController,
		onSave: @escaping (Word) -> Void,
		onDelete: @escaping (Word) -> Void
	) {
		self.words = words
		self.searchAction = searchAction
		self.didSelectWord = didSelectWord
		self.onSave = onSave
		self.onDelete = onDelete
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "Quiq Dict"

		setupTableView()
		setupSearchController()
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
		searchController.searchBar.keyboardType = .default

		navigationController?.navigationBar.barTintColor = .systemBackground
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = true

		debounceSearchBarTextField()
	}
}

// MARK: UITableViewControllerDataSource & UITableViewControllerDelegate
extension WordListViewController: UITableViewDataSource, UITableViewDelegate {
	// MARK: Required Data Source & Delegate Methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		words.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: WordCell.reuseID, for: indexPath) as? WordCell else {
			fatalError("Could not dequeue WordCell")
		}
		cell.configure(with: words[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		show(didSelectWord(words[indexPath.row]), sender: self)
	}

	// MARK: Cell Swipe Action Methods
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let saveAction = UIContextualAction(style: .normal, title: "Save") { [weak self] saveAction, view, completion in
			guard let self else {
				completion(false)
				return
			}
			self.onSave(self.words[indexPath.row])
			completion(true)
		}

		saveAction.backgroundColor = .systemGreen
		saveAction.image = .init(systemName: "archivebox")

		return .init(actions: [saveAction])
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
			guard let self else {
				completion(false)
				return
			}
			self.onDelete(self.words[indexPath.row])
			self.words.remove(at: indexPath.row)
			completion(true)
		}

		deleteAction.image = .init(systemName: "trash")
		return .init(actions: [deleteAction])

	}
}

// MARK: Actions
extension WordListViewController {
	@objc private func refresh() {
		isRefreshing = true
		searchAction(searchTerm, handleAPIResult)
	}

	private func handleAPIResult(_ result: Result<[Word], NetworkError>) {
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			self.isRefreshing = false
			switch result {
				case .success(let words):
					self.words = words
				case .failure(let error):
					self.showAlert(withError: error)
			}
		}
	}

	private func debounceSearchBarTextField() {
		cancellable = NotificationCenter.default.publisher(
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
	}
}
