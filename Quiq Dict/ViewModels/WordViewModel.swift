//
//  WordViewModel.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

struct WordViewModel {
	let title: String
	let subtitle: String

	init(word: Word) {
		title = word.word.capitalized
		if let definition = word.meanings.first?.definitions.first?.definition {
			subtitle = definition
		} else if let phon = word.phonetic {
			subtitle = phon
		} else if let text = word.phonetics.first?.text {
			subtitle = text
		} else {
			subtitle = "/ /"
		}
	}
}
