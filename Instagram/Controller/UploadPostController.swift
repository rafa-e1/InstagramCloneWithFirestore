//
//  UploadPostController.swift
//  Instagram
//
//  Created by RAFA on 7/7/24.
//

import UIKit

protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

final class UploadPostController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?
    
    var currentUser: User?
    
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var captionTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter caption.."
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = self
        textView.placeholderShouldCenter = false
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc func didTapDone() {
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let user = currentUser else { return }
        
        showLoader(true)
        
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
                return
            }
            
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    // MARK: - Helpers
    
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Share",
            style: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(
            top: photoImageView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 12,
            paddingRight: 12,
            height: 64
        )
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(
            top: captionTextView.bottomAnchor,
            right: view.rightAnchor,
            paddingRight: 12
        )
    }
}

// MARK: - UITextViewDelegate

extension UploadPostController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
