//
//  ResetPasswordController.swift
//  Instagram
//
//  Created by RAFA on 10/30/24.
//

import UIKit

class ResetPasswordController: UIViewController {

    // MARK: - Properties

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()

    private let iconImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.customButton(title: "Reset Password", action: #selector(handleResetPassword))
        return button
    }()

    private let emailTextField = CustomTextField(placeholder: "Email", isPassword: false)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    // MARK: - Actions

    @objc private func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handleResetPassword() {

    }

    // MARK: - Helpers

    func configureUI() {
        configureGradientLayer()

        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)

        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)

        let stack = UIStackView(
            arrangedSubviews: [
                emailTextField,
                resetPasswordButton
            ]
        )

        stack.axis = .vertical
        stack.spacing = 20

        view.addSubview(stack)
        stack.anchor(
            top: iconImage.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 32,
            paddingRight: 32
        )
    }
}
