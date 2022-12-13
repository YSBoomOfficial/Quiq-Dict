//
//  WordListDelegate.swift
//  Quiq Dict
//
//  Created by Yash Shah on 13/12/2022.
//

import UIKit

final class WordListDelegate: NSObject, UITableViewDelegate {
	private let onSave: ((Int) -> Void)?
	private let onDelete: ((Int) -> Void)!
	var didSelectWord: ((Int) -> Void)!

	init(onSave: ((Int) -> Void)? = nil, onDelete: ((Int) -> Void)? = nil) {
		self.onSave = onSave
		self.onDelete = onDelete
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		didSelectWord(indexPath.row)
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
			tableView.reloadSections(.init(integer: 0), with: .automatic)
			completion(true)
		}

		deleteAction.image = .init(systemName: "trash")
		return .init(actions: [deleteAction])
	}
}
