//
//  APIError.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

enum APIError: Error {
	case badURL
	case badResponse(Int)
}
