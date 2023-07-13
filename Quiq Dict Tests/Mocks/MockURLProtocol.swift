//
//  MockURLProtocol.swift
//  Quiq Dict Tests
//
//  Created by Yash Shah on 13/07/2023.
//

import Foundation

final class MockURLProtocol: URLProtocol {
	static var loadingHandler: (() -> (HTTPURLResponse, Data?))?

	override class func canInit(with request: URLRequest) -> Bool { true }

	override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

	override func startLoading() {
		guard let handler = Self.loadingHandler else {
			fatalError("`MockURLProtocol.loadingHandler` Loading Handler not set, please call MockURLProtocol.setHandler")
		}

		let (response, data) = handler()

		client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

		if let data { client?.urlProtocol(self, didLoad: data) }

		client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() {}
}
