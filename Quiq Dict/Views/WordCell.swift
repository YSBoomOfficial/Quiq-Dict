//
//  WordCell.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/08/2022.
//

import UIKit

// TODO: Add UI for WordCell
#warning("Add UI for WordCell")
class WordCell: UITableViewCell {
	static let reuseID = "WordCell"
	var viewModel: WordViewModel?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	func configure(with vm: WordViewModel) {
		textLabel?.text = vm.title
		detailTextLabel?.text = vm.subtitle
	}

}
