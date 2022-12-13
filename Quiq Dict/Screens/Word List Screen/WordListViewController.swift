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
	private let delegate: WordListDelegate
	private let searchAction: SearchAction?

    private var cancellable: AnyCancellable?

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

    deinit {
        cancellable = nil
    }

	init(
        dataSource: WordListDataSource,
		delegate: WordListDelegate,
		searchAction: SearchAction?
	) {
		self.dataSource = dataSource
		self.delegate = delegate
		self.searchAction = searchAction
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: View Setup
extension WordListViewController {
	private func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(WordCell.self, forCellReuseIdentifier: WordCell.reuseID)
		tableView.dataSource = dataSource
		tableView.delegate = delegate

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

// MARK: Actions
extension WordListViewController {
	private func handleAPIResult(_ result: Result<[Word], NetworkError>) {
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			switch result {
				case .success(let words):
                    self.dataSource.update(with: words)
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
