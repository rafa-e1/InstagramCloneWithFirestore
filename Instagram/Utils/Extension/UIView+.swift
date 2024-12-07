//
//  UIView+.swift
//  Instagram
//
//  Created by RAFA on 12/7/24.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    func createDivider() {
        backgroundColor = .systemGray2
    }
}
