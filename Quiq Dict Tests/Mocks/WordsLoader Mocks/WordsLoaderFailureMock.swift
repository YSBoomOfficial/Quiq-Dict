//
//  WordsLoaderFailureMock.swift
//  Quiq Dict Tests
//
//  Created by Yash Shah on 02/11/2022.
//

import Foundation
@testable import Quiq_Dict

final class WordsLoaderFailureMock: WordsLoader {
    func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], NetworkError>) -> Void) {
        completion(.failure(.badResponse(404)))
    }
}
