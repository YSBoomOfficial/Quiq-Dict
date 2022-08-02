//
//  UIViewController+ShowError.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import UIKit

// MARK: Show Error Alert
extension UIViewController {
	func show(error: Error) {
		let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default))
		self.showDetailViewController(alert, sender: self)
	}
}
