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
        let words = dataManager.search(for: word)
        if word.isEmpty {
            completion(.failure(.badResponse(404)))
        } else {
            completion(.success(words))
        }
	}
}
