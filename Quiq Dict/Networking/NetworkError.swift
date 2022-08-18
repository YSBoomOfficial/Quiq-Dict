//
//  APIError.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
	case badURL
	case badResponse(Int)
	case decodingError
	case other(Error)

	var description: String {
		switch self {
			case .badURL: return "The word you entered doesn't seem to exist."
			case .badResponse(let response):
				return response == 404 ? "The word you entered doesn't seem to exist." : "There is something wrong with the server. Response Code \(response)"
			case .decodingError: return "The Server's response couldn't be decoded correctly"
			case .other(let error):  return "Something went wrong. \(error.localizedDescription)"
		}
	}
}
