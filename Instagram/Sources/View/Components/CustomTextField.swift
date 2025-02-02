//
//  CustomTextField.swift
//  Instagram
//
//  Created by RAFA on 5/17/24.
//

import UIKit

import PinLayout
import Then

final class CustomTextField: UITextField {

    // MARK: - Properties

    private let spacer = UIView()

    // MARK: - Initializer

    init(placeholder: String, isPassword: Bool) {
        super.init(frame: .zero)
        
        configureTextField(placeholder: placeholder, isPassword: isPassword)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers

    private func configureTextField(placeholder: String, isPassword: Bool) {
        self.do {
            $0.leftView = spacer
            $0.leftViewMode = .always
            $0.borderStyle = .none
            $0.textColor = .white
            $0.keyboardAppearance = .dark
            $0.keyboardType = .emailAddress
            $0.backgroundColor = .white.withAlphaComponent(0.1)
            $0.isSecureTextEntry = isPassword
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
            $0.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)]
            )
        }
    }

    // MARK: - UI

    override func layoutSubviews() {
        super.layoutSubviews()

        spacer.pin.size(CGSize(width: 12, height: bounds.height))
        pin.height(50)
    }
}
