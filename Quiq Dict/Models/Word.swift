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

		var audioAccentRegion: String? {
			audio.components(separatedBy: "/").last?.components(separatedBy: ".").first?.components(separatedBy: "-").last?.uppercased()
		}
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


extension Word {
	static let example = Word(
		word: "hello",
		phonetic: nil,
		phonetics: [
			.init(
				text: nil,
				audio: "https://api.dictionaryapi.dev/media/pronunciations/en/hello-au.mp3",
				sourceUrl: "https://commons.wikimedia.org/w/index.php?curid=75797336",
				license: .init(
					name: "BY-SA 4.0",
					url: "https://creativecommons.org/licenses/by-sa/4.0"
				)
			),
			.init(
				text: "/həˈləʊ/",
				audio: "https://api.dictionaryapi.dev/media/pronunciations/en/hello-uk.mp3",
				sourceUrl: "https://commons.wikimedia.org/w/index.php?curid=9021983",
				license: .init(
					name: "BY 3.0 US",
					url: "https://creativecommons.org/licenses/by/3.0/us"
				)
			),
			.init(
				text: "/həˈloʊ/",
				audio: "",
				sourceUrl: nil,
				license: nil
			)
		],
		meanings: [
			.init(
				partOfSpeech: "noun",
				definitions: [
					.init(
						definition: "\"Hello!\" or an equivalent greeting.",
						synonyms: [],
						antonyms: [],
						example: nil
					),
				],
				synonyms: ["greeting"],
				antonyms: []
			),
			.init(
				partOfSpeech: "verb",
				definitions: [
					.init(
						definition: "To greet with \"hello\".",
						synonyms: [],
						antonyms: [],
						example: nil
					)
				],
				synonyms: [],
				antonyms: []
			),
			.init(
				partOfSpeech: "interjection",
				definitions: [
					.init(
						definition: "A greeting (salutation) said when meeting someone or acknowledging someone’s arrival or presence.",
						synonyms: [],
						antonyms: [],
						example: "Hello, everyone."
					),
					.init(
						definition: "A greeting used when answering the telephone.",
						synonyms: [],
						antonyms: [],
						example: "Hello? How may I help you?"
					),
					.init(
						definition: "A call for response if it is not clear if anyone is present or listening, or if a telephone conversation may have been disconnected.",
						synonyms: [],
						antonyms: [],
						example: "Hello? Is anyone there?"
					),
					.init(
						definition: "Used sarcastically to imply that the person addressed or referred to has done something the speaker or writer considers to be foolish.",
						synonyms: [],
						antonyms: [],
						example: "You just tried to start your car with your cell phone. Hello?"
					),
					.init(
						definition: "An expression of puzzlement or discovery.",
						synonyms: [],
						antonyms: [],
						example: "Hello! What’s going on here?"
					)
				],
				synonyms: [],
				antonyms: ["bye", "goodbye"]
			)
		],
		license: .init(
			name: "CC BY-SA 3.0",
			url: "https://creativecommons.org/licenses/by-sa/3.0"
		),
		sourceUrls: ["https://en.wiktionary.org/wiki/hello"]
	)
}
