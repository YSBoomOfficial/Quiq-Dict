//
//  LocalPhoneticsAudioLoader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

final class LocalPhoneticsAudioLoader: PhoneticsAudioLoader {
	private let dataManager: DataManaging

	init(dataManager: DataManaging) {
		self.dataManager = dataManager
	}

	func fetchPhoneticsAudio(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        print("\n💻 - LocalPhoneticsAudioLoader - fetchPhoneticsAudio - \(url)\n")
        if let data = dataManager.audio(for: url) {
            print("\n💻 - LocalPhoneticsAudioLoader - fetchPhoneticsAudio - Has Data\n")
			completion(.success(data))
		} else {
            print("\n💻 - LocalPhoneticsAudioLoader - fetchPhoneticsAudio - NO DATA\n")
			completion(.failure(.badResponse(404)))
		}
	}
}
