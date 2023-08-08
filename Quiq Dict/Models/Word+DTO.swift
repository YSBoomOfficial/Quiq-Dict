//
//  WordDTO.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

extension Word {
	struct DTO: Codable {
		let word: String
		let phonetic: String?
		let phonetics: [Phonetic.DTO]
		let meanings: [Meaning.DTO]
		let license: License.DTO
		let sourceUrls: [String]

		init(word: String, phonetic: String?, phonetics: [Phonetic.DTO], meanings: [Meaning.DTO], license: License.DTO, sourceUrls: [String]) {
			self.word = word
			self.phonetic = phonetic
			self.phonetics = phonetics
			self.meanings = meanings
			self.license = license
			self.sourceUrls = sourceUrls
		}

		init(model: Word) {
			self.word = model.word
			self.phonetic = model.phonetic
			self.phonetics = model.phonetics.map(Word.Phonetic.DTO.init(model:))
			self.meanings = model.meanings.map(Word.Meaning.DTO.init(model:))
			self.license = License.DTO(model: model.license)
			self.sourceUrls = model.sourceUrls
		}
	}
}

extension Word.Phonetic {
	struct DTO: Codable {
		let text: String?
		let audio: String
		let sourceUrl: String?
		let license: Word.License.DTO?

		init(text: String?, audio: String, sourceUrl: String?, license: Word.License.DTO?) {
			self.text = text
			self.audio = audio
			self.sourceUrl = sourceUrl
			self.license = license
		}

		init(model: Word.Phonetic) {
			self.text = model.text
			self.audio = model.audio
			self.sourceUrl = model.sourceUrl
			self.license = model.license.map(Word.License.DTO.init(model:))
		}
	}
}

extension Word.Meaning {
	struct DTO: Codable {
		let partOfSpeech: String
		let definitions: [Definition.DTO]
		let synonyms: [String]
		let antonyms: [String]

		init(partOfSpeech: String, definitions: [Definition.DTO], synonyms: [String], antonyms: [String]) {
			self.partOfSpeech = partOfSpeech
			self.definitions = definitions
			self.synonyms = synonyms
			self.antonyms = antonyms
		}

		init(model: Word.Meaning) {
			self.partOfSpeech = model.partOfSpeech
			self.definitions = model.definitions.map(Word.Meaning.Definition.DTO.init(model:))
			self.synonyms = model.synonyms
			self.antonyms = model.antonyms
		}
	}
}

extension Word.Meaning.Definition {
	struct DTO: Codable {
		let definition: String
		let synonyms: [String]
		let antonyms: [String]
		let example: String?

		init(model: Word.Meaning.Definition) {
			self.definition = model.definition
			self.synonyms = model.synonyms
			self.antonyms = model.antonyms
			self.example = model.example
		}

		init(definition: String, synonyms: [String], antonyms: [String], example: String?) {
			self.definition = definition
			self.synonyms = synonyms
			self.antonyms = antonyms
			self.example = example
		}
	}
}


extension Word.License {
	struct DTO: Codable {
		let name: String
		let url: String

		init(model: Word.License) {
			self.name = model.name
			self.url = model.url
		}

		init(name: String, url: String) {
			self.name = name
			self.url = url
		}
	}
}
