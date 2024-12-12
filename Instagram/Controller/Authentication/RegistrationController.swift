//
//  RegistrationController.swift
//  Instagram
//
//  Created by RAFA on 5/17/24.
//

import UIKit

final class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthenticationDelegate?

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()

    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.plusPhoto, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email", isPassword: false)
    private let passwordTextField = CustomTextField(placeholder: "Password", isPassword: true)
    private let fullnameTextField = CustomTextField(placeholder: "Fullname", isPassword: false)
    private let usernameTextField = CustomTextField(placeholder: "Username", isPassword: false)
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.customButton(title: "Sign Up", action: #selector(handleSignUp))
        return button
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(
            firstPart: "Already have an account?  ",
            secondPart: "Log in"
        )
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNotificationObservers()
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
    
    func configureUI() {
        configureGradientLayer()

        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)

        view.addSubview(addPhotoButton)
        addPhotoButton.centerX(inView: view)
        addPhotoButton.setDimensions(height: 140, width: 140)
        addPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(
            arrangedSubviews: [
                emailTextField,
                passwordTextField,
                fullnameTextField,
                usernameTextField,
                signUpButton
            ]
        )
        
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(
            top: addPhotoButton.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 32,
            paddingRight: 32
        )
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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
