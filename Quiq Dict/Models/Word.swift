//
//  Word+.swift
//  Quiq Dict
//
//  Created by Yash Shah on 08/08/2023.
//

import Foundation

// MARK: Word
struct Word: Equatable {
	let word: String
	let phonetic: String?
	let phonetics: [Phonetic]
	let meanings: [Meaning]
	let license: License
	let sourceUrls: [String]

	init(dto: Word.DTO) {
		word = dto.word
		phonetic = dto.phonetic
		phonetics = dto.phonetics.map(Phonetic.init(dto:))
		meanings = dto.meanings.map(Meaning.init(dto:))
		license = .init(dto: dto.license)
		sourceUrls = dto.sourceUrls
	}

	// MARK: Word.Phonetic
	struct Phonetic: Equatable {
		let text: String?
		let audio: String
		let sourceUrl: String?
		let license: License?

		init(dto: Word.Phonetic.DTO) {
			text = dto.text
			audio = dto.audio
			sourceUrl = dto.sourceUrl
			self.license = dto.license == nil ? nil : .init(dto: dto.license!)
		}
	}

	// MARK: Word.Meaning
	struct Meaning: Equatable {
		let partOfSpeech: String
		let definitions: [Definition]
		let synonyms: [String]
		let antonyms: [String]

		init(dto: Word.Meaning.DTO) {
			partOfSpeech = dto.partOfSpeech
			definitions = dto.definitions.map(Definition.init(dto:))
			synonyms = dto.synonyms
			antonyms = dto.antonyms
		}

		// MARK: Word.Meaning.Definition
		struct Definition: Equatable {
			let definition: String
			let synonyms: [String]
			let antonyms: [String]
			let example: String?

			init(dto: Word.Meaning.Definition.DTO) {
				definition = dto.definition
				synonyms = dto.synonyms
				antonyms = dto.antonyms
				example = dto.example
			}
		}
	}

	// MARK: Word.License
	struct License: Equatable {
		let name: String
		let url: String

		init(dto: Word.License.DTO) {
			name = dto.name
			url = dto.url
		}
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
