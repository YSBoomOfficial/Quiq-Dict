//
//  Word+Example.swift
//  Quiq Dict
//
//  Created by Yash Shah on 15/10/2022.
//

import Foundation

extension Word {
	static let example = Word(dto: Word.DTO.example)
}

extension Word.DTO {
	static let example = Word.DTO(
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
