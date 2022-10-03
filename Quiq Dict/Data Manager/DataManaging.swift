//
//  DataManaging.swift
//  Quiq Dict
//
//  Created by Yash Shah on 04/10/2022.
//

import Foundation

protocol DataManaging {
	var words: [Word] { get }

	func add(word: Word)
	func remove(word: Word)
	func search(for word: String) -> [Word]
	func audio(for wordUrlString: String) -> Data?
}
