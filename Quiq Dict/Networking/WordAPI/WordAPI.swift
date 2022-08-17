//
//  APIService.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

// https://dictionaryapi.dev/
// https://api.dictionaryapi.dev/api/v2/entries/en/<word>

final class WordAPI {
	static let shared = WordAPI()

	var sessionConfig: URLSessionConfiguration {
		let config = URLSessionConfiguration.default
		return config
	}

	func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], NetworkError>) -> Void) {
		guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word.lowercased())") else {
			completion(.failure(.badURL))
			print("\n\n\n badURL \n\n\n"); return
		}

		URLSession(configuration: sessionConfig).dataTask(with: url) { data, response, error in
			guard let status = (response as? HTTPURLResponse), 200...299 ~= status.statusCode else {
				completion(.failure(.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)))
				print("\n\n\n badResponse \((response as? HTTPURLResponse)?.statusCode ?? -1) \n\n\n "); return
			}

			if let error = error {
				completion(.failure(.other(error)))
				print("\n\n\n boo error \(error) - \(error.localizedDescription) \n\n\n"); return
			}

			if let data = data {
				do {
					let decoded = try JSONDecoder().decode([Word].self, from: data)
					completion(.success(decoded))
					print("\n\n\n yay data \n\n\n"); return
				} catch {
					completion(.failure(.decodingError))
					print("\n\n\n boo error \(error) - \(error.localizedDescription) \n\n\n"); return
				}
			}
		}.resume()
	}
}
