//
//  APIService.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

// MARK: WordsService Protocol
protocol WordsService {
	func loadDefinitions(for word: String, completion: @escaping (Result<[WordViewModel], Error>) -> Void)
}

// MARK: WordsService Fallback
extension WordsService {
	func fallback(_ fallback: WordsService) -> WordsService {
		ItemServiceWithFallback(primary: self, fallback: fallback)
	}
}

// MARK: WordsService Retry
extension WordsService {
	func retry(_ retryCount: UInt) -> WordsService {
		var service: WordsService = self
		for _ in 0..<retryCount {
			service = service.fallback(self)
		}
		return service
	}
}
