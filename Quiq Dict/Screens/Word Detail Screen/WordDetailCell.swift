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

	func configure(with word: Word) {
		self.word = word

		configureTitleLabelView()
		configurePhoneticsView()
		configureMeaningsView()
		configureBottomLicenseView()
		configureSourceURLsView()
	}

}

// MARK: Config Views for Title Label, License and Source URLs
extension WordDetailCell {
	// MARK: Title Label
	private func configureTitleLabelView() {
		let titleLabel = Label(attributedText: makeAttributedString(title: word.title, phonetics: word.phoneticText))
		titleLabel.bottomInset = 10
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .preferredFont(forTextStyle: .title1, compatibleWith: .init(legibilityWeight: .bold))
		stackView.addArrangedSubview(titleLabel)
	}

	// MARK: Bottom License View
	private func configureBottomLicenseView() {
		let bottomLicenseView = makeLicenseView(forLicense: word.license, with: .title2)
		stackView.addArrangedSubview(bottomLicenseView)
	}

	// MARK: sourceUrls
	private func configureSourceURLsView() {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.alignment = .leading
		stack.spacing = 5

		let sourceUrlsLabel = makeSubtitleLabel(withText: "Source URLs", font: .title2)
		stack.addArrangedSubview(sourceUrlsLabel)

		for url in word.sourceUrls {
			stack.addArrangedSubview(makeLinkButton(forURL: url))
		}

		stackView.addArrangedSubview(stack)
	}

}

// MARK: Config Views for Phonetics
extension WordDetailCell {
	private func configurePhoneticsView() {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.alignment = .leading
		stack.spacing = 5

		stack.addArrangedSubview(makeSubtitleLabel(withText: "Phonetics", font: .title2))

		for i in word.phonetics.indices {
			let phonetic = word.phonetics[i]

			let innerStackView = UIStackView()
			innerStackView.translatesAutoresizingMaskIntoConstraints = false
			innerStackView.axis = .horizontal
			innerStackView.alignment = .leading
			innerStackView.spacing = 5

			let textLabel = Label(attributedText: makeAttributedString(title: phonetic.audioAccentRegion, phonetics: phonetic.displayText))
			innerStackView.addArrangedSubview(textLabel)

			if !phonetic.audio.isEmpty {
				innerStackView.addArrangedSubview(makeAudioButton(withTag: i))
			} else {
				innerStackView.addArrangedSubview(Label(text: "Audio Unavailable"))
			}

			stack.addArrangedSubview(innerStackView)

			if let license = phonetic.license {
				stack.addArrangedSubview(makeLicenseView(forLicense: license, with: .title3))
			} else {
				stack.addArrangedSubview(makeSubtitleLabel(withText: "License: N/a", font: .title3))
			}
		}

		stackView.addArrangedSubview(stack)
	}

	// MARK: makeAudioButton
	private func makeAudioButton(withTag tag: Int) -> UIButton {
		let button = UIButton(type: .custom)
		button.setImage(.init(systemName: "speaker.wave.3.fill"), for: .normal)
		button.tag = tag
		button.addTarget(self, action: #selector(playAudio), for: .primaryActionTriggered)
		return button
	}

	@objc private func playAudio(_ sender: UIButton) {
		let audioURL = word.phonetics[sender.tag].audio
		PhoneticsAudioDownloader.shared.fetchPhoneticsAudio(from: audioURL) { [weak self] result in
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

// MARK: Config Views for Meanings
extension WordDetailCell {
	private func configureMeaningsView() {
		stackView.addArrangedSubview(makeSubtitleLabel(withText: "Meanings", font: .title2))
	}
}

// MARK: Helper methods to create views
extension WordDetailCell {
	// MARK: Make Subtitle Label
	private func makeSubtitleLabel(withText text: String, font: UIFont.TextStyle) -> Label {
		let label = Label(text: text)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: font, compatibleWith: .init(legibilityWeight: .bold))
		return label
	}

	// MARK: Reusable License View
	private func makeLicenseView(forLicense license: Word.License, with font: UIFont.TextStyle) -> UIStackView {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.alignment = .leading
		stack.spacing = 5

		let licenseLabel = makeSubtitleLabel(withText: "License: \(license.name)", font: font)
		stack.addArrangedSubview(licenseLabel)
		stack.addArrangedSubview(makeLinkButton(forURL: license.url))

		return stack
	}

	// MARK: makeLinkButton
	private func makeLinkButton(forURL url: String) -> UIButton {
		let button = UIButton(type: .custom)
		let attrString = NSAttributedString(string: url, attributes: [.font: UIFont.preferredFont(forTextStyle: .subheadline), .link: url])
		button.setAttributedTitle(attrString, for: .normal)
		button.addTarget(self, action: #selector(linkTapped), for: .primaryActionTriggered)
		return button
	}

	@objc private func linkTapped(_ sender: UIButton) {
		guard let buttonText = sender.attributedTitle(for: .normal)?.string,
			  let url = URL(string: buttonText) else { return }
		UIApplication.shared.open(link: url)
	}
}
