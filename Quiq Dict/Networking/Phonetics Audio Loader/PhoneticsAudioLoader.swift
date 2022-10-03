//
//  PhoneticsAudioLoader.swift
//  Quiq Dict
//
//  Created by Yash Shah on 19/08/2022.
//

import Foundation

protocol PhoneticsAudioLoader {
	func fetchPhoneticsAudio(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

