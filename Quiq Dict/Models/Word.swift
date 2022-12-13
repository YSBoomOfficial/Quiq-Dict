//
//  Word.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

// MARK: Word
struct Word: Codable, Equatable, Hashable {
	let word: String
	let phonetic: String?
	let phonetics: [Phonetic]
	let meanings: [Meaning]
	let license: License
	let sourceUrls: [String]

	// MARK: Word.Phonetic
	struct Phonetic: Codable, Equatable, Hashable {
		let text: String?
		let audio: String
		let sourceUrl: String?
		let license: License?
	}

	// MARK: Word.Meaning
	struct Meaning: Codable, Equatable, Hashable {
		let partOfSpeech: String
		let definitions: [Definition]
		let synonyms: [String]
		let antonyms: [String]

		// MARK: Word.Meaning.Definition
		struct Definition: Codable, Equatable, Hashable {
			let definition: String
			let synonyms: [String]
			let antonyms: [String]
			let example: String?
		}
	}

	// MARK: Word.License
	struct License: Codable, Equatable, Hashable {
		let name: String
		let url: String
	}
}

// MARK: Word + Helpers
extension Word {
	var title: String {
		word.capitalized
	}

	var firstMeaning: String {
        guard let meaning = meanings.first(where: { !$0.definitions.isEmpty }),
              let definition = meaning.definitions.first(where: { !$0.definition.isEmpty })?.definition else { return "No Definition found" }
		return definition
	}

	var phoneticText: String {
		if let phonetic { return phonetic }
		guard let phon = phonetics.first(where: { $0.text != nil }) else { return "N/a" }
		return phon.text!
	}
}

// MARK: Word.Phonetic + Helpers
extension Word.Phonetic {
	var audioURL: String? {
		audio.isEmpty ? nil : audio
	}

	var filename: String? {
		audioURL?.components(separatedBy: "/").split(separator: ".").first?.joined()
	}

	var audioAccentRegion: String? {
		guard let url = audioURL else { return nil }
		return url.components(separatedBy: "/").last?.components(separatedBy: ".").first?.components(separatedBy: "-").last?.uppercased()
	}

	var displayText: String {
		text ?? "N/a"
	}

	var noValues: Bool {
		text == nil && audioAccentRegion == nil && sourceUrl == nil && license == nil
	}
}
