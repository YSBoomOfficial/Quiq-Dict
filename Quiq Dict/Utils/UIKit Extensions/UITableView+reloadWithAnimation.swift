//
//  UITableView+reloadWithAnimation.swift
//  Quiq Dict
//
//  Created by Yash Shah on 14/12/2022.
//

import UIKit

extension UITableView {
	func reloadWithAnimation(section: IndexSet = .init(integer: 0), animation: UITableView.RowAnimation = .automatic) {
		reloadSections(section, with: animation)
	}
}
