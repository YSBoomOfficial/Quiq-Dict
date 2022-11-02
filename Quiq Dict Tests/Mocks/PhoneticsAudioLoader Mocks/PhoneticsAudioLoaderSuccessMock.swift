//
//  PhoneticsAudioLoaderSuccessMock.swift
//  Quiq Dict Tests
//
//  Created by Yash Shah on 02/11/2022.
//

import Foundation
@testable import Quiq_Dict

final class PhoneticsAudioLoaderSuccessMock: PhoneticsAudioLoader {
    func fetchPhoneticsAudio(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let path = Bundle(for: type(of: self)).path(forResource: "hello-uk", ofType: "mp3"),
              let data = FileManager.default.contents(atPath: path) else {
            fatalError("file hello.json not found")
        }
        completion(.success(data))
    }
}
