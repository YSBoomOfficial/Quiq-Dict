//
//  AttributionView.swift
//  Quiq Dict
//
//  Created by Yash Shah on 29/11/2022.
//

import UIKit

final class AttributionView: UIStackView {

	init(title: String, font: UIFont.TextStyle, links: [String]) {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		axis = .vertical
		alignment = .leading

		let sourceUrlsLabel = Label(text: title, font: font)
		addArrangedSubview(sourceUrlsLabel)

		for url in links {
			addArrangedSubview(LinkButton(url: url))
		}
	}

	convenience init(title: String, font: UIFont.TextStyle, link: String) {
		self.init(title: title, font: font, links: [link])
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
