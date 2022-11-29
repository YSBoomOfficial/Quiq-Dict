//
//  Label.swift
//  Quiq Dict
//
//  Created by Yash Shah on 19/08/2022.
//

import UIKit

class Label: UILabel {
	var topInset: CGFloat = 0
	var bottomInset: CGFloat = 0
	var leftInset: CGFloat = 0
	var rightInset: CGFloat = 0

	init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		numberOfLines = 0
	}

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) has not been implemented")
	}

	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
		super.drawText(in: rect.inset(by: insets))
	}

	override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + leftInset + rightInset,
					  height: size.height + topInset + bottomInset)
	}

	override var bounds: CGRect {
		didSet {
			// ensures this works within stack views if multi-line
			preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
		}
	}
}

extension Label {
	convenience init(text: String) {
		self.init()
		self.text = text
	}

	convenience init(attributedText: NSAttributedString) {
		self.init()
		self.attributedText = attributedText
	}

	convenience init(text: String, font: UIFont.TextStyle) {
		self.init(text: text)
		self.font = .preferredFont(
			forTextStyle: font,
			compatibleWith: .init(legibilityWeight: .bold)
		)
	}

}
