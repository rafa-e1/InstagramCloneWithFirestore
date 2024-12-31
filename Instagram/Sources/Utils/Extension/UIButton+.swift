//
//  UIButton+.swift
//  Instagram
//
//  Created by RAFA on 12/31/24.
//

import UIKit

extension UIButton {

    func attributedTitle(firstPart: String, secondPart: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 1, alpha: 0.87),
            .font: UIFont.systemFont(ofSize: 16)
        ]

        let attributedTitle = NSMutableAttributedString(
            string: "\(firstPart) ",
            attributes: attributes
        )

        let boldString: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 1, alpha: 0.87),
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]

        attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldString))

        setAttributedTitle(attributedTitle, for: .normal)
    }

    func customButton(title: String) {
        self.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
        setTitle(title, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.2)
        layer.cornerRadius = 5
        titleLabel?.font = .boldSystemFont(ofSize: 20)
        isEnabled = false
    }
}
