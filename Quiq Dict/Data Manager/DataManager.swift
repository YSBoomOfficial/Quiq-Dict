//
//  DataManager.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

final class DataManager: DataManaging {
	static let shared = DataManager(phoneticsLoader: RemotePhoneticsAudioLoader.shared)
	private let wordsSavePath = FileManager.documentsDirectory.appendingPathComponent("SavedWords")

	private let phoneticsLoader: PhoneticsAudioLoader

	// MARK: Words Storage
	private(set) var words = [Word]()

	init(phoneticsLoader: PhoneticsAudioLoader) {
		self.phoneticsLoader = phoneticsLoader
		load()
	}

	// MARK: Load & Save
	private func load() {
		do {
			let data = try Data(contentsOf: wordsSavePath)
			words = try JSONDecoder().decode([Word].self, from: data)
			print("DataManager - load() - Successful")
		} catch {
			words = []
			print("DataManager - load() - \(error)")
		}

		print("words.count = \(words.count)")
		words.forEach { print($0.word) }
	}

	private func save() {
		do {
			let data = try JSONEncoder().encode(words)
			try data.write(to: wordsSavePath, options: [.atomic, .completeFileProtection])
			print("DataManager - save() - Successful")
		} catch {
			print("DataManager - save() - \(error)")
		}

		print("words.count = \(words.count)")
		words.forEach { print($0.word) }
	}

	// MARK: Word - Add, Remove and Search operations
	func add(word: Word) {
		guard !words.contains(word) else { return }
		words.append(word)
		addAudio(for: word.phonetics)
		save()
	}

	func remove(word: Word) {
		words.removeAll { $0 == word }
		save()
	}

	func search(for word: String) -> [Word] {
		words.filter { $0.word == word }
	}

	// MARK: [Word.Phonetic] - Add, Remove and Search operations
	private func addAudio(for phonetics: [Word.Phonetic]) {
		for phon in phonetics {
			phoneticsLoader.fetchPhoneticsAudio(from: phon.audio) { result in
				switch result {
					case .success(let data):
						do {
							let path = FileManager.documentsDirectory.appendingPathComponent(phon.audio)
							try data.write(to: path, options: [.atomic, .completeFileProtection])
						} catch {
							print("DataManager - addAudio() - \(error)")
						}
					case .failure(let failure):
						print("DataManager - addAudio() - \(failure)")
				}
			}
		}
	}

	private func removeAudio(for phonetics: [Word.Phonetic]) {
		for phon in phonetics {

			do {
				let path = FileManager.documentsDirectory.appendingPathComponent(phon.audio)
				try FileManager.default.removeItem(atPath: path.absoluteString)
			} catch {
				print("DataManager - addAudio() - \(error)")
			}
		}
	}

	func audio(for wordUrlString: String) -> Data? {
		try? Data(
			contentsOf: FileManager
				.documentsDirectory
				.appendingPathComponent(wordUrlString)
		)
	}
}
