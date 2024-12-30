//
//  UIStackView+.swift
//  Instagram
//
//  Created by RAFA on 12/7/24.
//

import UIKit

extension UIStackView {

    func configureStackView(
        addArrangedSubviews: UIView...,
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fillEqually,
        spacing: CGFloat = 5
    ) {
        addArrangedSubviews.forEach(addArrangedSubview)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
