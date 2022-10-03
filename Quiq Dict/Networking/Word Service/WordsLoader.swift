//
//  WordsLoader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation

protocol WordsLoader {
	func fetchDefinitions(for word: String, completion: @escaping (Result<[Word], NetworkError>) -> Void)
}
