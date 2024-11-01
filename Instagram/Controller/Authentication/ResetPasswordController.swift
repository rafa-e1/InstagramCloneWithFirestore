//
//  ResetPasswordController.swift
//  Instagram
//
//  Created by RAFA on 10/30/24.
//

import UIKit

protocol ResetPasswordControllerDelegate: AnyObject {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {

    // MARK: - Properties

    private var viewModel = ResetPasswordViewModel()
    weak var delegate: ResetPasswordControllerDelegate?

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

    var email: String?

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
        guard let email = emailTextField.text else { return }

        showLoader(true)

        AuthService.resetPassword(withEmail: email) { error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }

            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
    }

    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }

        updateForm()
    }

    // MARK: - Helpers

    func configureUI() {
        configureGradientLayer()

        emailTextField.text = email
        viewModel.email = email
        updateForm()
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

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

// MARK: - FormViewModel

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        UIView.animate(withDuration: 0.5) {
            self.resetPasswordButton.backgroundColor = self.viewModel.buttonBackgroundColor
            self.resetPasswordButton.isEnabled = self.viewModel.formIsValid
        }

        UIView.transition(
            with: resetPasswordButton,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.resetPasswordButton.setTitleColor(self.viewModel.buttonTitleColor, for: .normal)
            }
        )
    }
}
