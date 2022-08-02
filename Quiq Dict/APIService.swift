//
//  APIService.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

// https://dictionaryapi.dev/
// https://api.dictionaryapi.dev/api/v2/entries/en/<word>

enum APIError: Error {
	case badURL
	case badResponse(Int)
}

final class APIService {
	static let shared = APIService()

	func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], Error>) -> Void) {
		guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else {
			completion(.failure(APIError.badURL))
			print("\n\n\n")
			print("badURL")
			return
		}

		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let status = (response as? HTTPURLResponse), 200...299 ~= status.statusCode else {
				completion(.failure(APIError.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)))
				print("\n\n\n")
				print("badResponse")
				return
			}

			if let error = error {
				completion(.failure(error))
				print("\n\n\n")
				print("boo error \(error.localizedDescription)")
				print("boo error \(error)")
				return
			}

			if let data = data {
				do {
					let decoded = try JSONDecoder().decode([Word].self, from: data)
					completion(.success(decoded))
					print("\n\n\n")
					print("yay data")
					return
				} catch {
					completion(.failure(error))
					print("\n\n\n")
					print("boo error \(error.localizedDescription)")
					print("boo error \(error)")
					return
				}
			}
		}.resume()
	}
}
