//
//  RemotePhoneticsAudioLoader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

final class RemotePhoneticsAudioLoader: PhoneticsAudioLoader {
	static let shared = RemotePhoneticsAudioLoader(session: .shared)
	private let session: URLSession

	init(session: URLSession) {
		self.session = session
	}

	func fetchPhoneticsAudio(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
		guard let url = URL(string: url) else {
			completion(.failure(.badURL))
			return
		}

		session.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(.other(error)))
				return
			}

			guard let status = (response as? HTTPURLResponse), 200...299 ~= status.statusCode else {
				completion(.failure(.badResponse((response as? HTTPURLResponse)?.statusCode ?? -1)))
				return
			}

			if let data = data {
				completion(.success(data))
				return
			}
		}.resume()
	}
}
