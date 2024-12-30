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

final class ResetPasswordController: BaseViewController {

    // MARK: - Properties

    private var viewModel = ResetPasswordViewModel()
    weak var delegate: ResetPasswordControllerDelegate?
    var email: String?

    private let backButton = UIButton(type: .system)
    private let iconImage = UIImageView()
    private let emailTextField = CustomTextField(placeholder: "Email", isPassword: false)
    private let resetPasswordButton = UIButton(type: .system)
    private let resetPasswordStackView = UIStackView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setAddTargets()
        updateForm()
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

    private func setAddTargets() {
        backButton.addTarget(
            self,
            action: #selector(handleDismissal),
            for: .touchUpInside
        )

        emailTextField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )

        resetPasswordButton.addTarget(
            self,
            action: #selector(handleResetPassword),
            for: .touchUpInside
        )
    }

    // MARK: - UI

    override func setStyle() {
        configureGradientLayer()

        backButton.do {
            $0.tintColor = .white
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        }

        iconImage.do {
            $0.image = .instagramLogoWhite
            $0.contentMode = .scaleAspectFill
        }

        emailTextField.text = email
        resetPasswordButton.customButton(title: "Reset Password")

        resetPasswordStackView.configureStackView(
            addArrangedSubviews: emailTextField, resetPasswordButton,
            spacing: 20
        )
    }

    override func setHierarchy() {
        view.addSubviews(backButton, iconImage, resetPasswordStackView)
    }

    override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(16)
        }

        iconImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.width.equalTo(120)
            $0.height.equalTo(80)
        }

        resetPasswordStackView.snp.makeConstraints {
            $0.top.equalTo(iconImage.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
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
