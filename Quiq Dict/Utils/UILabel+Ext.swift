//
//  UILabel+Ext.swift
//  Quiq Dict
//
//  Created by Yash Shah on 19/08/2022.
//

import UIKit

class Label: UILabel {
	var topInset: CGFloat
	var bottomInset: CGFloat
	var leftInset: CGFloat
	var rightInset: CGFloat

	init(topInset: CGFloat = 0, bottomInset: CGFloat = 0, leftInset: CGFloat = 0, rightInset: CGFloat = 0) {
		self.topInset = topInset
		self.bottomInset = bottomInset
		self.leftInset = leftInset
		self.rightInset = rightInset
		super.init(frame: .zero)
		numberOfLines = 0
	}

	convenience init(text: String) {
		self.init()
		self.text = text
	}

	convenience init(attributedText: NSAttributedString) {
		self.init()
		self.attributedText = attributedText
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
