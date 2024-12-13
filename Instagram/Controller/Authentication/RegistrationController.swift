//
//  RegistrationController.swift
//  Instagram
//
//  Created by RAFA on 5/17/24.
//

import UIKit

final class RegistrationController: BaseViewController {

    // MARK: - Properties

    weak var delegate: AuthenticationDelegate?
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    private let backButton = UIButton(type: .system)
    private let addPhotoButton = UIButton(type: .system)
    private let emailTextField = CustomTextField(placeholder: "Email", isPassword: false)
    private let passwordTextField = CustomTextField(placeholder: "Password", isPassword: true)
    private let fullnameTextField = CustomTextField(placeholder: "Fullname", isPassword: false)
    private let usernameTextField = CustomTextField(placeholder: "Username", isPassword: false)
    private let signUpFormStackView = UIStackView()
    private let signUpButton = UIButton(type: .system)
    private let alreadyHaveAccountButton = UIButton(type: .system)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAddTargets()
    }
    
    // MARK: - Actions

    @objc private func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credentials = AuthCredentials(
            email: email,
            password: password,
            fullname: fullname,
            username: username,
            profileImage: profileImage
        )
        
        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationDidComplete()
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleProfilePhotoSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // MARK: - Helpers

    private func setAddTargets() {
        backButton.addTarget(
            self,
            action: #selector(handleDismissal),
            for: .touchUpInside
        )

        addPhotoButton.addTarget(
            self,
            action: #selector(handleProfilePhotoSelect),
            for: .touchUpInside
        )

        signUpButton.addTarget(
            self,
            action: #selector(handleSignUp),
            for: .touchUpInside
        )

        alreadyHaveAccountButton.addTarget(
            self,
            action: #selector(handleShowLogin),
            for: .touchUpInside
        )

        [emailTextField, passwordTextField, fullnameTextField, usernameTextField].forEach {
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
    }

    // MARK: - UI

    override func setStyle() {
        configureGradientLayer()

        backButton.do {
            $0.tintColor = .white
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        }

        addPhotoButton.do {
            $0.tintColor = .white
            $0.setImage(.plusPhoto, for: .normal)
        }

        signUpButton.customButton(title: "Sign Up")

        signUpFormStackView.configureStackView(
            addArrangedSubviews:
                emailTextField,
                passwordTextField,
                fullnameTextField,
                usernameTextField,
                signUpButton,
            spacing: 20
        )

        alreadyHaveAccountButton.attributedTitle(
            firstPart: "Already have an account?  ",
            secondPart: "Log in"
        )
    }

    override func setHierarchy() {
        view.addSubviews(
            backButton,
            addPhotoButton,
            signUpFormStackView,
            alreadyHaveAccountButton
        )
    }

    override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(16)
        }

        addPhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.size.equalTo(140)
        }

        signUpFormStackView.snp.makeConstraints {
            $0.top.equalTo(addPhotoButton.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }

        alreadyHaveAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - FormViewModel

extension RegistrationController: FormViewModel {

    func updateForm() {
        UIView.animate(withDuration: 0.5) {
            self.signUpButton.backgroundColor = self.viewModel.buttonBackgroundColor
            self.signUpButton.isEnabled = self.viewModel.formIsValid
        }
        
        UIView.transition(
            with: signUpButton,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.signUpButton.setTitleColor(self.viewModel.buttonTitleColor, for: .normal)
            }
        )
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderWidth = 1
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.setImage(
            selectedImage.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        
        self.dismiss(animated: true)
    }
}
