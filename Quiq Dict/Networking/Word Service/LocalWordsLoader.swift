//
//  LocalWordsLoader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

final class LocalWordsLoader: WordsLoader {
	static let shared = LocalWordsLoader(dataManager: DataManager.shared)
	private let dataManager: DataManaging

	init(dataManager: DataManaging) {
		self.dataManager = dataManager
	}

	func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], NetworkError>) -> Void) {
		completion(.success(dataManager.search(for: word)))
	}
}
