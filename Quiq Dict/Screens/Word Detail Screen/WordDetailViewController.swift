//
//  WordDetailViewController.swift
//  Quiq Dict
//
//  Created by Yash Shah on 26/08/2022.
//

import UIKit

class WordDetailViewController: UIViewController {
	private let tableView = UITableView(frame: .zero, style: .insetGrouped)
	private let word: Word

	init(word: Word) {
		self.word = word
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = word.title
		navigationItem.largeTitleDisplayMode = .never
		setupTableView()
	}
}

// MARK: View Setup
extension WordDetailViewController {
	private func setupTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(WordDetailCell.self, forCellReuseIdentifier: WordDetailCell.reuseID)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.rowHeight = UITableView.automaticDimension

		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}
}

// MARK: UITableViewControllerDataSource & UITableViewControllerDelegate
extension WordDetailViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: WordDetailCell.reuseID, for: indexPath) as? WordDetailCell else {
			fatalError("Could not dequeue WordCell")
		}
		cell.parent = self
		cell.configure(with: word)
		return cell
	}
}
