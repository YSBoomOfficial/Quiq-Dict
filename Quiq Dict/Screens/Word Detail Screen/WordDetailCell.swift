//
//  WordDetailCell.swift
//  Quiq Dict
//
//  Created by Yash Shah on 26/08/2022.
//

import UIKit

class WordDetailCell: UITableViewCell {
	static let reuseID = "WordDetailCell"
	private let stackView = UIStackView()

	private let titleLabel = Label()

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
		])

		NSLayoutConstraint.activate([
			contentView.layoutMarginsGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
			contentView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
			contentView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
			contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
		])

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.bottomInset = 10
		stackView.addArrangedSubview(titleLabel)
	}

	func configure(with word: Word) {
		titleLabel.attributedText = makeAttributedString(title: word.title, phonetics: word.phoneticText)
	}
}
