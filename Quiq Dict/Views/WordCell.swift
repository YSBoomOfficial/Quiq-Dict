//
//  WordCell.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/08/2022.
//

import UIKit

class WordCell: UITableViewCell {
	static let reuseID = "WordCell"

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	private func makeAttributedString(title: String, phonetics: String) -> NSAttributedString {
		let titleAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.label
		]

		let subtitleAttributes = [
			NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
		]

		let titleString = NSMutableAttributedString(string: "\(title) ", attributes: titleAttributes)
		let subtitleString = NSAttributedString(string: phonetics, attributes: subtitleAttributes)

		titleString.append(subtitleString)

		return titleString
	}

	func configure(with word: Word) {
		textLabel?.attributedText = makeAttributedString(title: word.title, phonetics: word.phoneticText)
		detailTextLabel?.text = word.firstMeaning
		detailTextLabel?.numberOfLines = 0
	}

}
