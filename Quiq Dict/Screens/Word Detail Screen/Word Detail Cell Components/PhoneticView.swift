//
//  PhoneticView.swift
//  Quiq Dict
//
//  Created by Yash Shah on 29/11/2022.
//

import UIKit

final class PhoneticView: UIStackView {
	private let action: () -> Void

	init(phonetic: Word.Phonetic, buttonAction: @escaping () -> Void) {
		self.action = buttonAction
		super.init(frame: .zero)

		translatesAutoresizingMaskIntoConstraints = false
		axis = .vertical
		alignment = .leading
		spacing = 5

		let phoneticHStack = UIStackView()
		phoneticHStack.translatesAutoresizingMaskIntoConstraints = false
		phoneticHStack.axis = .horizontal
		phoneticHStack.alignment = .leading
		phoneticHStack.spacing = 5

		let textLabel = Label(attributedText: makeAttributedString(title: phonetic.audioAccentRegion ?? "", phonetics: phonetic.displayText))
		phoneticHStack.addArrangedSubview(textLabel)

		if phonetic.audioURL != nil {
			let audioButton = UIButton(type: .custom)
			audioButton.setImage(.init(systemName: "speaker.wave.3"), for: .normal)
			audioButton.addTarget(self, action: #selector(didPressButon), for: .primaryActionTriggered)
			phoneticHStack.addArrangedSubview(audioButton)
		} else {
			let audioUnavailableLabel = Label(text: "Audio Unavailable")
			audioUnavailableLabel.numberOfLines = 1
			phoneticHStack.addArrangedSubview(audioUnavailableLabel)
		}

		addArrangedSubview(phoneticHStack)

		// MARK: Phonetics.License
		if let license = phonetic.license {
			addArrangedSubview(
				AttributionView(
					title: "License: \(license.name)",
					font: .title2,
					link: license.url
				)
			)
		}

	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc func didPressButon() {
		action()
	}

}
