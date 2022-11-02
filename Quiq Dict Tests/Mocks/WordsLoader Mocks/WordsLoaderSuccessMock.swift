//
//  WordsLoaderSuccessMock.swift
//  Quiq Dict Tests
//
//  Created by Yash Shah on 02/11/2022.
//

import Foundation
@testable import Quiq_Dict

final class WordsLoaderSuccessMock: WordsLoader {
    func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], NetworkError>) -> Void) {
        guard let path = Bundle(for: type(of: self)).path(forResource: "hello", ofType: "json"),
                let data = FileManager.default.contents(atPath: path) else {
            fatalError("file hello.json not found")
        }
        let decoded = try! JSONDecoder().decode([Word].self, from: data)
        completion(.success(decoded))
    }
}
