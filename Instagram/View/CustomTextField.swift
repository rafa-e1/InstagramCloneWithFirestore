//
//  CustomTextField.swift
//  Instagram
//
//  Created by RAFA on 5/17/24.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, isPassword: Bool) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        keyboardType = .emailAddress
        backgroundColor = .white.withAlphaComponent(0.1)
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)]
        )
        isSecureTextEntry = isPassword
        autocorrectionType = .no
        spellCheckingType = .no
        setHeight(50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
