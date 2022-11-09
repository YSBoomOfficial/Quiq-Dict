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

    typealias SearchAction = (String, @escaping (Result<[Word], NetworkError>) -> Void) -> Void

    private let dataSource: WordListDataSource
	private let searchAction: SearchAction?
    private let onSave: ((Int) -> Void)?
    private let onDelete: ((Int) -> Void)?

    var didSelectWord: ((Int) -> Void)!

    private var cancellable: AnyCancellable?

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

    deinit {
        cancellable = nil
    }

	init(
        dataSource: WordListDataSource,
		searchAction: SearchAction?,
		onSave: ((Int) -> Void)? = nil,
        onDelete: ((Int) -> Void)? = nil
	) {
		self.dataSource = dataSource
		self.searchAction = searchAction
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
		tableView.dataSource = dataSource
		tableView.delegate = self

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

// MARK: UITableViewControllerDelegate
extension WordListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
        didSelectWord?(indexPath.row)
	}

	// MARK: Cell Swipe Action Methods
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard onSave != nil else { return nil }

		let saveAction = UIContextualAction(style: .normal, title: "Save") { [weak self] _, _, completion in
			guard let self else { completion(false); return }
            self.onSave!(indexPath.row)
			completion(true)
		}

		saveAction.backgroundColor = .systemGreen
		saveAction.image = .init(systemName: "archivebox")

		return .init(actions: [saveAction])
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard onDelete != nil else { return nil }

		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
			guard let self else { completion(false); return }
            self.onDelete!(indexPath.row)
            self.tableView.reloadSections(.init(integer: 0), with: .automatic)
			completion(true)
		}

		deleteAction.image = .init(systemName: "trash")
		return .init(actions: [deleteAction])
	}
}

// MARK: Actions
extension WordListViewController {
	private func handleAPIResult(_ result: Result<[Word], NetworkError>) {
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			switch result {
				case .success(let words):
                    self.dataSource.updateDataSource(with: words)
                    self.tableView.reloadSections(.init(integer: 0), with: .automatic)
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
				if let self, let text = value, !text.isEmpty {
                    self.searchAction?(text, self.handleAPIResult)
				}
			}
		}

	}
}
