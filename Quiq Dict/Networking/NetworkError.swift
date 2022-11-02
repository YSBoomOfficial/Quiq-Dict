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
			case .badURL: return "We couldn't conduct this operation, please try again."
			case .badResponse(let response):
				switch response {
					case 404: return "The server couldn't find what you were looking for"
					default: return "Server returned an unknown response code: \(response)"
				}
			case .decodingError: return "The Server's response couldn't be decoded correctly"
			case .other(let error):  return "Something went wrong. \(error.localizedDescription)"
		}
	}
}
