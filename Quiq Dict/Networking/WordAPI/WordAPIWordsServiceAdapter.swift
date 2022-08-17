//
//  WordAPIWordsServiceAdapter.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import Foundation
import UIKit

struct WordAPIWordsServiceAdapter: WordsService {
	let api: WordAPI

	func loadDefinitions(for word: String, completion: @escaping (Result<[WordViewModel], NetworkError>) -> Void) {
		api.fetchDefinitions(for: word) { result in
			switch result {
				case .success(let words):
					completion(
						.success(
							words.map(WordViewModel.init)
						)
					)
				case .failure(let error):
					completion(.failure(error))
			}
		}
	}

}
