//
//  makeAttributedString.swift
//  Quiq Dict
//
//  Created by Yash Shah on 19/08/2022.
//

import UIKit

func makeAttributedString(title: String, phonetics: String) -> NSAttributedString {
	let titleAttributes: [NSAttributedString.Key: Any] = [
		.foregroundColor: UIColor.label
	]

	let subtitleAttributes: [NSAttributedString.Key: Any] = [
		.foregroundColor: UIColor.secondaryLabel
	]

	switch (title.isEmpty, phonetics.isEmpty) {
		case (true, true): return .init(string: "")
		case (true, false): // Title is empty
			return NSMutableAttributedString(string: phonetics, attributes: subtitleAttributes)
		case (false, true): // Phonetics is empty
			return NSMutableAttributedString(string: title, attributes: titleAttributes)
		case (false, false): // Both have non-empty values
			let titleString = NSMutableAttributedString(string: "\(title) ", attributes: titleAttributes)
			let subtitleString = NSMutableAttributedString(string: phonetics, attributes: subtitleAttributes)
			titleString.append(subtitleString)
			return titleString
	}

}
