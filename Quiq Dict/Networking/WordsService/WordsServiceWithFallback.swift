//
//  WordsServiceWithFallback.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

// Composite Pattern
struct ItemServiceWithFallback: WordsService {
	let primary: WordsService
	let fallback: WordsService

	func loadDefinitions(for word: String, completion: @escaping (Result<[WordViewModel], Error>) -> Void) {
		primary.loadDefinitions(for: word) { result in
			switch result {
				case .success: completion(result)
				case .failure: fallback.loadDefinitions(for: word, completion: completion)
			}
		}
	}

}
