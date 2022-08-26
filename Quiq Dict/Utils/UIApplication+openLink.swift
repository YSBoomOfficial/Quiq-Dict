//
//  OpenLink.swift
//  Quiq Dict
//
//  Created by Yash Shah on 26/08/2022.
//

import UIKit

extension UIApplication {
	func open(link: URL) {
		if canOpenURL(link) {
			open(link) { success in
				guard success == false else { return }
				if let controller = (self.connectedScenes.first!.delegate as? SceneDelegate)?.window?.rootViewController {
					controller.showAlert(title: "Something went wrong")
				}
			}
		} else {
			if let controller = (self.connectedScenes.first!.delegate as? SceneDelegate)?.window?.rootViewController {
				controller.showAlert(title: "Something went wrong", message: "Could not open link")
			}
		}
	}
}
