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
			if words.isEmpty {
				navigationItem.leftBarButtonItem!.isEnabled = false
			} else {
				navigationItem.leftBarButtonItem!.isEnabled = true
			}
		}
	}

	private var audioService: PhoneticsAudioLoader
	private var searchAction: (String, @escaping (Result<[Word], NetworkError>) -> Void) -> Void
	private var saveAction: ((Word) -> Void)?
	private var deleteAction: ((Word) -> Void)?

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
		words: [Word] = [],
		audioService: PhoneticsAudioLoader,
		searchAction: @escaping (String, @escaping (Result<[Word], NetworkError>) -> Void) -> Void,
		saveAction: ((Word) -> Void)? = nil,
		deleteAction: ((Word) -> Void)? = nil
	) {
		self.words = words
		self.audioService = audioService
		self.searchAction = searchAction
		self.saveAction = saveAction
		self.deleteAction = deleteAction
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Quiq Dict"

		navigationItem.leftBarButtonItem = .init(title: "Clear", style: .done, target: self, action: #selector(clearTapped))
		navigationItem.leftBarButtonItem!.isEnabled = false

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
		show(WordDetailViewController(word: words[indexPath.row], audioService: audioService), sender: self)
	}

	// MARK: Cell Swipe Action Methods
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		guard let save = saveAction else { return nil }
		let saveAction = UIContextualAction(style: .normal, title: "Save") { [weak self] saveAction, view, completion in
			guard let self else {
				completion(false)
				return
			}
			save(self.words[indexPath.row])
			completion(true)
		}

		saveAction.backgroundColor = .systemGreen
		saveAction.image = .init(systemName: "archivebox")

		return .init(actions: [saveAction])
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		guard let delete = deleteAction else { return nil }
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
			guard let self else {
				completion(false)
				return
			}
			delete(self.words[indexPath.row])
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

	@objc private func clearTapped(_ sender: UIBarButtonItem) {
		words = []
		sender.isEnabled = false
	}
}
