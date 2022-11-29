//
//  LinkButton.swift
//  Quiq Dict
//
//  Created by Yash Shah on 29/11/2022.
//


import UIKit

final class LinkButton: UIButton {
	private let urlString: String

	init(url: String) {
		self.urlString = url
		super.init(frame: .zero)

		let displayText = url.trimmingPrefix("https://").trimmingPrefix("www")
		let attrString = NSAttributedString(
			string: displayText,
			attributes: [.font: UIFont.preferredFont(forTextStyle: .subheadline), .link: url]
		)

		setAttributedTitle(attrString, for: .normal)
		addTarget(self, action: #selector(linkTapped), for: .primaryActionTriggered)
		accessibilityIdentifier = "link_\(displayText)"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc private func linkTapped(_ sender: UIButton) {
		guard let url = URL(string: urlString) else { return }
		UIApplication.shared.open(link: url)
	}
}
