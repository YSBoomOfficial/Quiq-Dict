//
//  UIViewController+ShowError.swift
//  Quiq Dict
//
//  Created by Yash Shah on 02/08/2022.
//

import UIKit

// MARK: Show Error Alert
extension UIViewController {
    func showAlert(withError error: NetworkError) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        showDetailViewController(alert, sender: self)
    }

    func showAlert(withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        showDetailViewController(alert, sender: self)
    }

    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        showDetailViewController(alert, sender: self)
    }

}
