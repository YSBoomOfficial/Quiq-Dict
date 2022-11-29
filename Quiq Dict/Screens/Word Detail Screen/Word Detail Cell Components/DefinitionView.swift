//
//  DefinitionView.swift
//  Quiq Dict
//
//  Created by Yash Shah on 29/11/2022.
//

import UIKit

final class DefinitionView: UIStackView {
	
	init(definition: Word.Meaning.Definition) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		axis = .vertical
		alignment = .leading
		spacing = 5

		if !definition.definition.isEmpty {
			let defLabel = Label(text: "- \(definition.definition)")
			defLabel.accessibilityIdentifier = "definition_\(definition.definition)"
			addArrangedSubview(defLabel)
		}

		if !definition.synonyms.isEmpty {
			addArrangedSubview(Label(text: "Synonyms:", font: .subheadline))
			addArrangedSubview(Label(text: definition.synonyms.map(\.capitalized).joined(separator: ", ")))
		}

		if !definition.antonyms.isEmpty {
			addArrangedSubview(Label(text: "Antonyms:", font: .subheadline))
			addArrangedSubview(Label(text: definition.antonyms.map(\.capitalized).joined(separator: ", ")))
		}

		if let example = definition.example {
			let exLabel = Label(text: "Example: \"\(example)\"")
			exLabel.accessibilityIdentifier = "example_\(example)"
			addArrangedSubview(exLabel)
		}
		
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
