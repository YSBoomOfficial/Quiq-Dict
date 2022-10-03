//
//  LocalPhoneticsAudioLoader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

final class LocalPhoneticsAudioLoader: PhoneticsAudioLoader {
	static let shared = LocalPhoneticsAudioLoader(dataManager: DataManager.shared)
	private let dataManager: DataManaging

	init(dataManager: DataManaging) {
		self.dataManager = dataManager
	}

	func fetchPhoneticsAudio(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
		if let data = dataManager.audio(for: url) {
			completion(.success(data))
		} else {
			completion(.failure(.badResponse(404)))
		}
	}
}
