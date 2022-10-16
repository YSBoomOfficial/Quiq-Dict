//
//  DataManager.swift
//  Quiq Dict
//
//  Created by Yash Shah on 03/10/2022.
//

import Foundation

final class DataManager: DataManaging {
	private let wordsSavePath = FileManager.documentsDirectory.appendingPathComponent("SavedWords")

	private let phoneticsLoader: PhoneticsAudioLoader

	// MARK: Words Storage
	private(set) var words = [Word]()

	init(phoneticsLoader: PhoneticsAudioLoader) {
		self.phoneticsLoader = phoneticsLoader
		print("\n💻 - DataManager - init - \(wordsSavePath)\n")
		load()
	}

	// MARK: Load & Save
	private func load() {
		do {
			let data = FileManager.default.contents(atPath: wordsSavePath.absoluteString) ?? Data()
			words = try JSONDecoder().decode([Word].self, from: data)
			print("\n💻 - DataManager - load() - Successful\n")
		} catch {
			words = []
			print("\n💻 - DataManager - load() - ⚠️ERROR⚠️: \(error.localizedDescription) - \(error)\n")
		}

		print("\n💻 - words.count = \(words.count)\n")
		words.forEach { print(" - \($0.title)") }
		print("\n")
	}

	private func save() {
		do {
			let data = try JSONEncoder().encode(words)
			try data.write(to: wordsSavePath, options: [.atomic, .completeFileProtection])
			print("\n💻 - DataManager - save() - Successful\n")
		} catch {
			print("\n💻 - DataManager - save() - ⚠️ERROR⚠️: \(error.localizedDescription) - \(error)\n")
		}

		print("\n💻 - words.count = \(words.count)\n")
		words.forEach { print(" - \($0.title)") }
		print("\n")
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
		removeAudio(for: word.phonetics)
		save()
	}

	func search(for word: String) -> [Word] {
		words.filter { $0.word == word }
	}

	// MARK: [Word.Phonetic] - Add, Remove and Search operations
	private func addAudio(for phonetics: [Word.Phonetic]) {
		for phon in phonetics {
			if let url = phon.audioURL, let filename = phon.filename {
				phoneticsLoader.fetchPhoneticsAudio(from: url) { result in
					switch result {
						case .success(let data):
							do {
								let path = FileManager.documentsDirectory.appendingPathComponent(filename)
								try data.write(to: path, options: [.atomic, .completeFileProtection])
							} catch {
								print("\n💻 - DataManager - addAudio() - result.success - ⚠️ERROR⚠️: \(error.localizedDescription) - \(error)\n")
							}
						case .failure(let error):
							print("\n💻 - DataManager - addAudio() - result.failure - ⚠️ERROR⚠️: \(error.localizedDescription) - \(error)\n")
					}
				}
			}
		}
	}

	private func removeAudio(for phonetics: [Word.Phonetic]) {
		for phon in phonetics {
			if let filename = phon.filename {
				do {
					let path = FileManager.documentsDirectory.appendingPathComponent(filename)
					try FileManager.default.removeItem(atPath: path.absoluteString)
				} catch {
					print("\n💻 - DataManager - addAudio() - ⚠️ERROR⚠️: \(error.localizedDescription) - \(error)\n")
				}
			}
		}
	}

	func audio(for wordUrlString: String) -> Data? {
		guard let filename = wordUrlString.components(separatedBy: "/").last?.replacingOccurrences(of: ".mp3", with: "") else { return nil }
		return FileManager.default.contents(atPath: filename)
	}
}
