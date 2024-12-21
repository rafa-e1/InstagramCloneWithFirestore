//
//  LoginController.swift
//  Instagram
//
//  Created by RAFA on 5/17/24.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}

final class LoginController: BaseViewController {

    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?

    private let gradient = CAGradientLayer()
    private let iconImage = UIImageView()
    private let emailTextField = CustomTextField(placeholder: "Email", isPassword: false)
    private let passwordTextField = CustomTextField(placeholder: "Password", isPassword: true)
    private let loginButton = UIButton(type: .system)
    private let forgotPasswordButton = UIButton(type: .system)
    private let loginStackView = UIStackView()
    private let dontHaveAccountButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAddTargets()
    }
    
    // MARK: - Actions
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationDidComplete()
        }
    }
    
    @objc func handleShowResetPassword() {
        let controller = ResetPasswordController()
        controller.delegate = self
        controller.email = emailTextField.text
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }

    private func setAddTargets() {
        [emailTextField, passwordTextField].forEach {
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }

        loginButton.addTarget(
            self,
            action: #selector(handleLogin),
            for: .touchUpInside
        )

        forgotPasswordButton.addTarget(
            self,
            action: #selector(handleShowResetPassword),
            for: .touchUpInside
        )

        dontHaveAccountButton.addTarget(
            self,
            action: #selector(handleShowSignUp),
            for: .touchUpInside
        )
    }

    // MARK: - UI

    override func setStyle() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black

        configureGradientLayer()

        gradient.do {
            $0.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
            $0.locations = [0, 1]
        }

        iconImage.do {
            $0.image = .instagramLogoWhite
            $0.contentMode = .scaleAspectFill
        }

        loginButton.customButton(title: "Log in")

        forgotPasswordButton.attributedTitle(
            firstPart: "Forgot your password? ",
            secondPart: "Get help signing in."
        )

        loginStackView.configureStackView(
            addArrangedSubviews:
                emailTextField,
                passwordTextField,
                loginButton,
                forgotPasswordButton,
            spacing: 20
        )

        dontHaveAccountButton.attributedTitle(
            firstPart: "Don't have an account?  ",
            secondPart: "Sign Up"
        )
    }

    override func setHierarchy() {
        view.layer.addSublayer(gradient)
        view.addSubviews(iconImage, loginStackView, dontHaveAccountButton)
    }

    override func setLayout() {
        gradient.frame = view.frame

        iconImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(80)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }

        loginStackView.snp.makeConstraints {
            $0.top.equalTo(iconImage.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }

        dontHaveAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - FormViewModel

extension LoginController: FormViewModel {
    
    func updateForm() {
        UIView.animate(withDuration: 0.5) {
            self.loginButton.backgroundColor = self.viewModel.buttonBackgroundColor
            self.loginButton.isEnabled = self.viewModel.formIsValid
        }
        
        UIView.transition(
            with: loginButton,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.loginButton.setTitleColor(self.viewModel.buttonTitleColor, for: .normal)
            }
        )
    }
}

// MARK: - ResetPasswordControllerDelegate

extension LoginController: ResetPasswordControllerDelegate {

    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController) {
        navigationController?.popViewController(animated: true)

        showMessage(
            withTitle: "Success",
            message: "We sent a link to your email to reset your password"
        )
    }
}
