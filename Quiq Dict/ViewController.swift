//
//  ViewController.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import UIKit

class ViewController: UITableViewController {
	let reuseID = "WordCell"
	var words = [Word]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Quiq Dict"
		view.backgroundColor = .systemBackground

		tableView = .init(frame: .zero, style: .insetGrouped)
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

		APIService.shared.fetchDefinitions(for: "word") { [weak self] result in
			switch result {
				case .success(let words):
					DispatchQueue.mainAsyncIfNeeded {
						self?.words = words
						self?.tableView.reloadData()
					}
				case .failure(let error):
					DispatchQueue.mainAsyncIfNeeded {
						self?.show(error: error)
					}
			}
		}

	}

}

// MARK: UITableViewController Delegate & DataSource
extension ViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		words.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let word = words[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
		cell.textLabel?.text = word.word
		cell.detailTextLabel?.text = word.phonetic

		return cell
	}
}

// MARK: Actions
extension ViewController {
	@objc private func refresh() {
		refreshControl?.beginRefreshing()

		APIService.shared.fetchDefinitions(for: "hello") { [weak self] result in
			switch result {
				case .success(let words):
					self?.words = words
				case .failure(let error):
					self?.show(error: error)
			}
		}

		refreshControl?.endRefreshing()
	}

}
