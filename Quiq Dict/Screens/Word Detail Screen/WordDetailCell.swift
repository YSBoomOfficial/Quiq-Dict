//
//  WordDetailCell.swift
//  Quiq Dict
//
//  Created by Yash Shah on 26/08/2022.
//

import UIKit

class WordDetailCell: UITableViewCell {
	static let reuseID = "WordDetailCell"
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
		// MARK: Title Label
		let titleLabel = Label(attributedText: makeAttributedString(title: word.title, phonetics: word.phoneticText))
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .preferredFont(forTextStyle: .title1)
		titleLabel.bottomInset = 10
		stackView.addArrangedSubview(titleLabel)

		// MARK: Phonetics
		let phoneticsLabel = makeSubtitleLabel(withText: "Phonetics")
		stackView.addArrangedSubview(phoneticsLabel)

		// MARK: Meanings
		let meaningsLabel = makeSubtitleLabel(withText: "Meanings")
		stackView.addArrangedSubview(meaningsLabel)


		// MARK: License
		let licenseLabel = makeSubtitleLabel(withText: "License")
		stackView.addArrangedSubview(licenseLabel)

		let licenseNameLabel = Label(text: word.license.name)
		licenseNameLabel.translatesAutoresizingMaskIntoConstraints = false
		licenseNameLabel.font = .preferredFont(forTextStyle: .headline)

		stackView.addArrangedSubview(licenseNameLabel)
		stackView.addArrangedSubview(makeLinkButton(forURL: word.license.url))

		// MARK: sourceUrls
		let sourceUrlsLabel = makeSubtitleLabel(withText: "Source URLs")
		stackView.addArrangedSubview(sourceUrlsLabel)
		for url in word.sourceUrls {
			stackView.addArrangedSubview(makeLinkButton(forURL: url))
		}
	}
}

// MARK: Helper methods to create views
extension WordDetailCell {
	// MARK: Make Subtitle Label
	private func makeSubtitleLabel(withText text: String, font: UIFont.TextStyle = .title2) -> Label {
		let label = Label(text: text)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: font)
		return label
	}

	// MARK: makeLinkButton
	private func makeLinkButton(forURL url: String) -> UIButton {
		let button = UIButton(type: .custom)
		let attrString = NSAttributedString(string: url, attributes: [.link: url])
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
