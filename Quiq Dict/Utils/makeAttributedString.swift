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

	let titleString = NSMutableAttributedString(string: "\(title) ", attributes: titleAttributes)
	let subtitleString = NSAttributedString(string: phonetics, attributes: subtitleAttributes)

	titleString.append(subtitleString)

	return titleString
}
