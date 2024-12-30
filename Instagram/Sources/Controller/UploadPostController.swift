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

final class UploadPostController: BaseViewController {

    // MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?

    var currentUser: User?
    var selectedImage: UIImage? {
        didSet { photoImageView.image = selectedImage }
    }
    
    private let photoImageView = UIImageView()
    private let captionTextView = InputTextView()
    private let characterCountLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
    }

    // MARK: - Actions
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDone() {
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

    private func setDelegates() {
        captionTextView.delegate = self
    }

    private func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }

    // MARK: - UI

    override func setStyle() {
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

        photoImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
        }

        captionTextView.do {
            $0.placeholderText = "Enter caption.."
            $0.font = .systemFont(ofSize: 16)
            $0.placeholderShouldCenter = false
        }

        characterCountLabel.do {
            $0.textColor = .lightGray
            $0.font = .systemFont(ofSize: 14)
            $0.text = "0/100"
        }
    }

    override func setHierarchy() {
        view.addSubviews(photoImageView, captionTextView, characterCountLabel)
    }

    override func setLayout() {
        photoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.size.equalTo(180)
        }

        captionTextView.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(64)
        }

        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(captionTextView.snp.bottom)
            $0.trailing.equalTo(-12)
        }
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
