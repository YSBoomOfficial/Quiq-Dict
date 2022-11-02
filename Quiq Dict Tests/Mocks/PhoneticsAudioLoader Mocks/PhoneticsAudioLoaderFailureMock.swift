//
//  PhoneticsAudioLoaderFailureMock.swift
//  Quiq Dict Tests
//
//  Created by Yash Shah on 02/11/2022.
//

import Foundation
@testable import Quiq_Dict

final class PhoneticsAudioLoaderFailureMock: PhoneticsAudioLoader {
    func fetchPhoneticsAudio(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        completion(.failure(.badURL))
    }
}
