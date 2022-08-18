//
//  APIService.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

// Docs - https://dictionaryapi.dev/
// Endpoint - https://api.dictionaryapi.dev/api/v2/entries/en/<word>

final class WordAPI: WordsService {
	static let shared = WordAPI()

	var sessionConfig: URLSessionConfiguration {
		let config = URLSessionConfiguration.default
		return config
	}

	func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], NetworkError>) -> Void) {
		guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word.lowercased())") else {
			completion(.failure(.badURL)); return
		}

		URLSession(configuration: sessionConfig).dataTask(with: url) { data, response, error in
			guard let status = (response as? HTTPURLResponse), 200...299 ~= status.statusCode else {
				completion(.failure(.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1))); return
			}

			if let error = error {
				completion(.failure(.other(error))); return
			}

			if let data = data {
				do {
					let decoded = try JSONDecoder().decode([Word].self, from: data)
					completion(.success(decoded)); return
				} catch {
					completion(.failure(.decodingError)); return
				}
			}
		}.resume()
	}
}
