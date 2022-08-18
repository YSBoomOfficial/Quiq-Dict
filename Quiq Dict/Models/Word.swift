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

	// MARK: Word.License
	struct License: Codable {
		let name: String
		let url: String
	}

	var title: String {
		word.capitalized
	}

	var firstMeaning: String {
		guard !meanings.isEmpty,
			  let meaning = meanings.first(where: { !$0.definitions.isEmpty }),
			  !meaning.definitions.isEmpty,
			  let definition = meaning.definitions.first(where: { $0.definition != "" })?.definition else { return "No Definition found" }
		return definition
	}

	var phoneticText: String {
		if let phonetic = phonetic {
			return phonetic
		} else {
			guard let phon = phonetics.first(where: { $0.text != nil }) else { return "" }
			return phon.text!
		}
	}
}
