//
//  RemoteWordsLoader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

// Docs - https://dictionaryapi.dev/
// Endpoint - https://api.dictionaryapi.dev/api/v2/entries/en/<word>

final class RemoteWordsLoader: WordsLoader {
	private let session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}

	func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], NetworkError>) -> Void) {
		guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word.lowercased())") else {
			completion(.failure(.badURL))
			return
		}

        session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(.other(error)))
                return
            }

            guard let status = (response as? HTTPURLResponse), 200...299 ~= status.statusCode else {
                completion(.failure(.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)))
                return
            }

            guard let data else {
                completion(.failure(.badResponse(404)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Word].self, from: data)
                completion(.success(decoded))
                return
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }.resume()
	}
}
