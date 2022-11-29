//
//  MeaningView.swift
//  Quiq Dict
//
//  Created by Yash Shah on 29/11/2022.
//

import UIKit

final class MeaningView: UIStackView {

	init(meaning: Word.Meaning) {
		super.init(frame: .zero)

		translatesAutoresizingMaskIntoConstraints = false
		axis = .vertical
		alignment = .leading
		spacing = 5

		addArrangedSubview(Label(text: "Part of Speech: \(meaning.partOfSpeech.capitalized)", font: .title3))

		if !meaning.synonyms.isEmpty {
			addArrangedSubview(Label(text: "General Synonyms:", font: .headline))
			addArrangedSubview(Label(text: meaning.synonyms.map(\.capitalized).joined(separator: ", ")))
		}

		if !meaning.antonyms.isEmpty {
			addArrangedSubview(Label(text: "General Antonyms:", font: .headline))
			addArrangedSubview(Label(text: meaning.antonyms.map(\.capitalized).joined(separator: ", ")))
		}

		if !meaning.definitions.isEmpty {
			addArrangedSubview(Label(text: "Definitions:", font: .headline))
			for definition in meaning.definitions {
				addArrangedSubview(
					DefinitionView(definition: definition)
				)
			}
		}

		
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
