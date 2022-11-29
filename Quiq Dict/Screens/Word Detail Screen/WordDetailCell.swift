//
//  WordDetailCell.swift
//  Quiq Dict
//
//  Created by Yash Shah on 26/08/2022.
//

import AVFoundation
import UIKit

class WordDetailCell: UITableViewCell {
	static let reuseID = "WordDetailCell"
	weak var parent: UIViewController?

	private var player: AVAudioPlayer?

	private var word: Word!
	private var service: PhoneticsAudioLoader!

	private let stackView = UIStackView()

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		selectionStyle = .none
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .leading
		stackView.spacing = 5
		contentView.addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
		])
	}

	func configure(with word: Word, using service: PhoneticsAudioLoader) {
		self.word = word
		self.service = service
		configure()
	}
}

extension WordDetailCell {
	// MARK: Configure View
	private func configure() {
		configureTitleLabelView()

		if !word.phonetics.isEmpty {
			configurePhoneticsView()
		}

		if !word.meanings.isEmpty {
			configureMeaningsView()
		}

		// MARK: License
		stackView.addArrangedSubview(
			AttributionView(
				title: "License: \(word.license.name)",
				font: .title2,
				link: word.license.url
			)
		)

		// MARK: Source URLs
		if !word.sourceUrls.isEmpty {
			stackView.addArrangedSubview(
				AttributionView(
					title: "Source URLs",
					font: .title2,
					links: word.sourceUrls
				)
			)
		}
	}

	// MARK: Title Label
	private func configureTitleLabelView() {
		let titleLabel = Label(attributedText: makeAttributedString(title: word.title, phonetics: word.phoneticText))
		titleLabel.bottomInset = 5
		titleLabel.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
		stackView.addArrangedSubview(titleLabel)
	}

	// MARK: Phonetics
	private func configurePhoneticsView() {
		let phoneticsVStack = UIStackView()
		phoneticsVStack.translatesAutoresizingMaskIntoConstraints = false
		phoneticsVStack.axis = .vertical
		phoneticsVStack.alignment = .leading
		phoneticsVStack.spacing = 5

		let phoneticsLabel = Label(text: "Phonetics", font: .title2)
		phoneticsLabel.topInset = 5
		phoneticsVStack.addArrangedSubview(phoneticsLabel)

		for phonetic in word.phonetics where phonetic.noValues == false  {
			phoneticsVStack.addArrangedSubview(
				PhoneticView(phonetic: phonetic) { [weak self] in
					self?.playAudio(for: phonetic)
				}
			)
		}

		stackView.addArrangedSubview(phoneticsVStack)
	}

	private func playAudio(for phonetic: Word.Phonetic) {
		service.fetchPhoneticsAudio(from: phonetic.audioURL!) { [weak self] result in
			DispatchQueue.main.async {
				switch result {
					case let .success(data):
						do {
							self?.player = try AVAudioPlayer(data: data)
							self?.player!.play()
						} catch {
							self?.parent?.showAlert(withError: error)
						}
					case let .failure(networkError):
						self?.parent?.showAlert(withError: networkError)
				}
			}
		}
	}

	// MARK: Meanings
	private func configureMeaningsView() {
		let meaningsVStack = UIStackView()
		meaningsVStack.translatesAutoresizingMaskIntoConstraints = false
		meaningsVStack.axis = .vertical
		meaningsVStack.alignment = .leading
		meaningsVStack.spacing = 10

		let meaningLabel = Label(text: "Meanings", font: .title2)
		meaningLabel.topInset = 5
		meaningsVStack.addArrangedSubview(meaningLabel)


		for meaning in word.meanings {
			meaningsVStack.addArrangedSubview(
				MeaningView(meaning: meaning)
			)
		}

		stackView.addArrangedSubview(meaningsVStack)
	}

}
