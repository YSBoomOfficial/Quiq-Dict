//
//  WordsLoaderTests.swift
//  Quiq Dict Tests
//
//  Created by Yash Shah on 02/11/2022.
//

import XCTest
@testable import Quiq_Dict

final class WordsLoaderTests: XCTestCase {
    var loader: WordsLoader!

    override func tearDown() {
        super.tearDown()
        loader = nil
    }

    func test_words_loader_returns_correct_response() {
        loader = WordsLoaderSuccessMock()
        loader.fetchDefinitions(for: "hello") { result in
            switch result {
                case .success(let words):
                    XCTAssertEqual(words.count, 1, "There should 1 word in the array")
                    XCTAssertEqual(words.first!, Word.example, "Response decoded from the JSON file should be the same as the example")
                case .failure(_): XCTFail("No Error Should be thrown")
            }
        }

    }

    func test_words_loader_fails_with_error() {
        loader = WordsLoaderFailureMock()
        loader.fetchDefinitions(for: "hello") { result in
            switch result {
                case .success(_): XCTFail("No Data Should be Returned")
                case .failure(let error):
                    XCTAssertEqual(error.description, "The server couldn't find what you were looking for", "Incorrect error message")
            }
        }
    }

}
