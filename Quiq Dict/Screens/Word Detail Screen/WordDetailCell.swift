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
		translatesAutoresizingMaskIntoConstraints = false
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

		configureTitleLabelView()

		if !word.phonetics.isEmpty {
			configurePhoneticsView()
		}

		if !word.meanings.isEmpty {
			configureMeaningsView()
		}

		configureBottomLicenseView()

		if !word.sourceUrls.isEmpty {
			configureSourceURLsView()
		}

	}
}

// MARK: Title Label Config and Subtitle Label method
extension WordDetailCell {
	private func configureTitleLabelView() {
		let titleLabel = Label(attributedText: makeAttributedString(title: word.title, phonetics: word.phoneticText))
		titleLabel.bottomInset = 5
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
		stackView.addArrangedSubview(titleLabel)
	}

	private func makeSubtitleLabel(withText text: String, font: UIFont.TextStyle) -> Label {
		let subtitleLabel = Label(text: text)
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
		subtitleLabel.font = .preferredFont(forTextStyle: font, compatibleWith: .init(legibilityWeight: .bold))
		return subtitleLabel
	}
}

// MARK: Config Views for Phonetics
extension WordDetailCell {
	private func configurePhoneticsView() {
		let phoneticsVStack = UIStackView()
		phoneticsVStack.translatesAutoresizingMaskIntoConstraints = false
		phoneticsVStack.axis = .vertical
		phoneticsVStack.alignment = .leading
		phoneticsVStack.spacing = 5

		let phoneticsLabel = makeSubtitleLabel(withText: "Phonetics", font: .title2)
		phoneticsLabel.topInset = 5
		phoneticsVStack.addArrangedSubview(phoneticsLabel)

		for i in word.phonetics.indices {
			if word.phonetics[i].noValues == false {
				phoneticsVStack.addArrangedSubview(makePhoneticView(for: i))
			}
		}

		stackView.addArrangedSubview(phoneticsVStack)
	}

	private func makePhoneticView(for index: Int) -> UIStackView {
		let phonetic = word.phonetics[index]

		let phoneticHStack = UIStackView()
		phoneticHStack.translatesAutoresizingMaskIntoConstraints = false
		phoneticHStack.axis = .horizontal
		phoneticHStack.alignment = .leading
		phoneticHStack.spacing = 5

		let textLabel = Label(attributedText: makeAttributedString(title: phonetic.audioAccentRegion ?? "", phonetics: phonetic.displayText))
		phoneticHStack.addArrangedSubview(textLabel)

		if !phonetic.audio.isEmpty {
			phoneticHStack.addArrangedSubview(makeAudioButton(withTag: index))
		} else {
			let audioUnavailableLabel = Label(text: "Audio Unavailable")
			audioUnavailableLabel.numberOfLines = 1
			phoneticHStack.addArrangedSubview(audioUnavailableLabel)
		}

		let phoneticAndLicenseVStack = UIStackView()
		phoneticAndLicenseVStack.translatesAutoresizingMaskIntoConstraints = false
		phoneticAndLicenseVStack.axis = .vertical
		phoneticAndLicenseVStack.alignment = .leading
		phoneticAndLicenseVStack.spacing = 5

		phoneticAndLicenseVStack.addArrangedSubview(phoneticHStack)

		if let license = phonetic.license {
			phoneticAndLicenseVStack.addArrangedSubview(makeLicenseView(forLicense: license, with: .title3))
		}

		return phoneticAndLicenseVStack
	}

	private func makeAudioButton(withTag tag: Int) -> UIButton {
		let audioButton = UIButton(type: .custom)
		audioButton.setImage(.init(systemName: "speaker.wave.3"), for: .normal)
		audioButton.tag = tag
		audioButton.addTarget(self, action: #selector(playAudio), for: .primaryActionTriggered)
		return audioButton
	}

	@objc private func playAudio(_ sender: UIButton) {
		service.fetchPhoneticsAudio(from: word.phonetics[sender.tag].audio) { [weak self] result in
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
}

// MARK: Config Views for Meanings
extension WordDetailCell {
	private func configureMeaningsView() {
		let meaningsVStack = UIStackView()
		meaningsVStack.translatesAutoresizingMaskIntoConstraints = false
		meaningsVStack.axis = .vertical
		meaningsVStack.alignment = .leading
		meaningsVStack.spacing = 10

		let meaningLabel = makeSubtitleLabel(withText: "Meanings", font: .title2)
		meaningLabel.topInset = 5
		meaningsVStack.addArrangedSubview(meaningLabel)


		for meaning in word.meanings {
			meaningsVStack.addArrangedSubview(makeMeaningView(forMeaning: meaning))
		}

		stackView.addArrangedSubview(meaningsVStack)
	}

	private func makeMeaningView(forMeaning meaning: Word.Meaning) -> UIStackView {
		let meaningVStack = UIStackView()
		meaningVStack.translatesAutoresizingMaskIntoConstraints = false
		meaningVStack.axis = .vertical
		meaningVStack.alignment = .leading
		meaningVStack.spacing = 5

		meaningVStack.addArrangedSubview(makeSubtitleLabel(withText: "Part of Speech: \(meaning.partOfSpeech.capitalized)", font: .title3))

		if !meaning.synonyms.isEmpty {
			meaningVStack.addArrangedSubview(makeSubtitleLabel(withText: "General Synonyms:", font: .headline))
			meaningVStack.addArrangedSubview(Label(text: meaning.synonyms.map(\.capitalized).joined(separator: ", ")))
		}

		if !meaning.antonyms.isEmpty {
			meaningVStack.addArrangedSubview(makeSubtitleLabel(withText: "General Antonyms:", font: .headline))
			meaningVStack.addArrangedSubview(Label(text: meaning.antonyms.map(\.capitalized).joined(separator: ", ")))
		}

		if !meaning.definitions.isEmpty {
			meaningVStack.addArrangedSubview(makeSubtitleLabel(withText: "Definitions:", font: .headline))
			for definition in meaning.definitions {
				meaningVStack.addArrangedSubview(makeDefinitionView(forDefinition: definition))
			}
		}

		return meaningVStack
	}

	private func makeDefinitionView(forDefinition definition: Word.Meaning.Definition) -> UIStackView {
		let definitionVStack = UIStackView()
		definitionVStack.translatesAutoresizingMaskIntoConstraints = false
		definitionVStack.axis = .vertical
		definitionVStack.alignment = .leading
		definitionVStack.spacing = 5

		if !definition.definition.isEmpty {
			definitionVStack.addArrangedSubview(Label(text: "- \(definition.definition)"))
		}

		if !definition.synonyms.isEmpty {
			definitionVStack.addArrangedSubview(makeSubtitleLabel(withText: "Synonyms:", font: .subheadline))
			definitionVStack.addArrangedSubview(Label(text: definition.synonyms.map(\.capitalized).joined(separator: ", ")))
		}

		if !definition.antonyms.isEmpty {
			definitionVStack.addArrangedSubview(makeSubtitleLabel(withText: "Antonyms:", font: .subheadline))
			definitionVStack.addArrangedSubview(Label(text: definition.antonyms.map(\.capitalized).joined(separator: ", ")))
		}

		if let example = definition.example {
			definitionVStack.addArrangedSubview(Label(text: "Example: \"\(example)\""))
		}

		return definitionVStack
	}
}

// MARK: Config Views for License
extension WordDetailCell {
	private func configureBottomLicenseView() {
		stackView.addArrangedSubview(makeLicenseView(forLicense: word.license, with: .title2))
	}

	private func makeLicenseView(forLicense license: Word.License, with font: UIFont.TextStyle) -> UIStackView {
		let licenseVStack = UIStackView()
		licenseVStack.translatesAutoresizingMaskIntoConstraints = false
		licenseVStack.axis = .vertical
		licenseVStack.alignment = .leading

		let licenseLabel = makeSubtitleLabel(withText: "License: \(license.name)", font: font)
		licenseLabel.topInset = 5
		licenseVStack.addArrangedSubview(licenseLabel)
		licenseVStack.addArrangedSubview(makeLinkButton(forURL: license.url))

		return licenseVStack
	}

	private func makeLinkButton(forURL url: String) -> UIButton {
		let linkButton = UIButton()
		let attrString = NSAttributedString(string: url, attributes: [.font: UIFont.preferredFont(forTextStyle: .subheadline), .link: url])
		linkButton.setAttributedTitle(attrString, for: .normal)
		linkButton.addTarget(self, action: #selector(linkTapped), for: .primaryActionTriggered)
		return linkButton
	}

	@objc private func linkTapped(_ sender: UIButton) {
		guard let buttonText = sender.attributedTitle(for: .normal)?.string,
			  let url = URL(string: buttonText) else { return }
		UIApplication.shared.open(link: url)
	}
}

// MARK: Config Views for Source URLs
extension WordDetailCell {
	// MARK: sourceUrls
	private func configureSourceURLsView() {
		let sourceURLsVStack = UIStackView()
		sourceURLsVStack.translatesAutoresizingMaskIntoConstraints = false
		sourceURLsVStack.axis = .vertical
		sourceURLsVStack.alignment = .leading
		sourceURLsVStack.spacing = 5

		let sourceUrlsLabel = makeSubtitleLabel(withText: "Source URLs", font: .title2)
		sourceUrlsLabel.topInset = 5
		sourceURLsVStack.addArrangedSubview(sourceUrlsLabel)

		for url in word.sourceUrls {
			sourceURLsVStack.addArrangedSubview(makeLinkButton(forURL: url))
		}

		stackView.addArrangedSubview(sourceURLsVStack)
	}
}
