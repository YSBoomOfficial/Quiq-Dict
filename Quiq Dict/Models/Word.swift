//
//  Word.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

// MARK: Word
struct Word: Codable {
	let word: String
	let phonetic: String?
	let phonetics: [Phonetic]
	let meanings: [Meaning]
	let license: License
	let sourceUrls: [String]

	// MARK: Word.Phonetic
	struct Phonetic: Codable {
		let text: String?
		let audio: String
		let sourceUrl: String?
		let license: License?
	}

	// MARK: Word.Meaning
	struct Meaning: Codable {
		let partOfSpeech: String
		let definitions: [Definition]
		let synonyms: [String]
		let antonyms: [String]

		// MARK: Word.Meaning.Definition
		struct Definition: Codable {
			let definition: String
			let synonyms: [String]
			let antonyms: [String]
			let example: String?
		}
	}

	// MARK: License
	struct License: Codable {
		let name: String
		let url: String
	}
}
