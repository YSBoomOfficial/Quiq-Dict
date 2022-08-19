//
//  Phonetics Audio Downloader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 19/08/2022.
//

import Foundation

final class PhoneticsAudioDownloader {
	static let shared = PhoneticsAudioDownloader(sessionConfig: .default)

	let sessionConfig: URLSessionConfiguration

	init(sessionConfig: URLSessionConfiguration) {
		self.sessionConfig = sessionConfig
	}

	func fetchPhoneticsAudio(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
		guard let url = URL(string: url) else {
			completion(.failure(.badURL))
			return
		}

		URLSession(configuration: sessionConfig).dataTask(with: url) { data, response, error in
			guard let status = (response as? HTTPURLResponse), 200...299 ~= status.statusCode else {
				completion(.failure(.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)))
				return
			}

			if let error = error {
				completion(.failure(.other(error)))
				return
			}

			if let data = data {
				completion(.success(data))
				return
			}
		}.resume()
	}
}
