//
//  LocalWordsLoader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

final class LocalWordsLoader: WordsLoader {
	private let dataManager: DataManaging

	init(dataManager: DataManaging) {
		self.dataManager = dataManager
	}

	func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], NetworkError>) -> Void) {
		guard !word.isEmpty else {
			print("\n💻 - LocalWordsLoader - fetchDefinitions - empty string passed in, return all words\n")
			completion(.success(dataManager.words))
			return
		}

		print("\n💻 - LocalWordsLoader - fetchDefinitions - \(word)\n")
        let words = dataManager.search(for: word)
        if words.isEmpty {
			print("\n💻 - LocalWordsLoader - fetchDefinitions - No Data, return all words\n")
			completion(.success(dataManager.words))
        } else {
            completion(.success(words))
            print("\n💻 - LocalWordsLoader - fetchDefinitions - Has Data\n")
            print("\n💻 - words.count = \(words.count)\n")
            words.forEach { print(" - \($0.title)") }
        }
	}
}
