//
//  OpenLink.swift
//  Quiq Dict
//
//  Created by Yash Shah on 26/08/2022.
//

import UIKit

extension UIApplication {
	var rootViewController: UIViewController? {
		(connectedScenes.first!.delegate as? SceneDelegate)?.window?.rootViewController
	}

	func open(link: URL) {
		if canOpenURL(link) {
			open(link) { success in
                if !success {
                    self.rootViewController?.showAlert(title: "Something went wrong", message: "Could not open link")
                }
			}
        } else {
            rootViewController?.showAlert(title: "Something went wrong", message: "Could not open link")
        }
	}
}
