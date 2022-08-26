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

	func configure(with word: Word) {
		textLabel?.attributedText = makeAttributedString(title: word.title, phonetics: word.phoneticText)
		detailTextLabel?.text = word.firstMeaning
		detailTextLabel?.numberOfLines = 0
	}

}
