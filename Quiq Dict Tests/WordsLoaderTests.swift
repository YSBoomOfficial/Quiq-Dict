//
//  WordsLoaderTests.swift
//  Quiq Dict Tests
//
//  Created by Yash Shah on 02/11/2022.
//

import XCTest
@testable import Quiq_Dict

final class WordsLoaderTest: XCTestCase {
	private let word = "hello"
	private let url = URL(string: API.urlString(forWord: "hello"))!

	private var loader: WordsLoader!
	private var session: URLSession!

	override func setUp() {
		super.setUp()
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		session = .init(configuration: config)
	}

	override func tearDown() {
		super.tearDown()
		loader = nil
	}

	func test_fetchDefinitions_returnsData() {
		let data = try! JSONEncoder().encode(Word.DTO.example)

		MockURLProtocol.loadingHandler = {
			let response = HTTPURLResponse(
				url: self.url,
				statusCode: 200,
				httpVersion: nil,
				headerFields: nil
			)

			return (response!, data)
		}

		loader = RemoteWordsLoader(session: session)
		loader.fetchDefinitions(for: word) { result in
			switch result {
				case .success(let words):
					XCTAssertEqual(words.count, 1, "There should 1 word in the array")
					XCTAssertEqual(
						words.first!,
						Word.example,
						"Response decoded from the JSON file should be the same as the example"
					)
				case .failure(_): XCTFail("No Error Should be thrown")
			}
		}

	}

	func test_fetchDefinitions_returnsNotFoundError() {
		MockURLProtocol.loadingHandler = {
			let response = HTTPURLResponse(
				url: self.url,
				statusCode: 404,
				httpVersion: nil,
				headerFields: nil
			)

			return (response!, nil)
		}

		loader = RemoteWordsLoader(session: session)
		loader.fetchDefinitions(for: word) { result in
			switch result {
				case .success(_): XCTFail("No Data Should be Returned")
				case .failure(let error):
					XCTAssertEqual(
						error,
						NetworkError.badResponse(404),
						"Should be invalid status code"
					)
			}
		}
	}

}
