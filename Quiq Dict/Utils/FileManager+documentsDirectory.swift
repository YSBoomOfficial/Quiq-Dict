//
//  FileManager+documentsDirectory.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

extension FileManager {
	static var documentsDirectory: URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths.first!
	}
}
