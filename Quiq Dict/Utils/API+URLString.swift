//
//  API+URLString.swift
//  Quiq Dict
//
//  Created by Yash Shah on 13/07/2023.
//

import Foundation

enum API {
	static func urlString(forWord word: String) -> String {
		"https://api.dictionaryapi.dev/api/v2/entries/en/\(word.lowercased())"
	}
}
