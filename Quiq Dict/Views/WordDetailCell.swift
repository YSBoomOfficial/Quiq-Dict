//
//  WordDetailCell.swift
//  Quiq Dict
//
//  Created by Yash Shah on 19/08/2022.
//

import UIKit

class WordDetailCell: UITableViewCell {
	static let reuseID = "WordDetailCell"
	let label = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	func configure(with word: Word) {
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = word.title
		contentView.addSubview(label)

		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: centerXAnchor),
			label.centerYAnchor.constraint(equalTo: centerYAnchor),
		])
	}

}

