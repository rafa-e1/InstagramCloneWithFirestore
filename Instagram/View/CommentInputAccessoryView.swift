//
//  CommentInputAccessoryView.swift
//  Instagram
//
//  Created by RAFA on 7/12/24.
//

import UIKit

import SnapKit
import Then

protocol CommentInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String)
}

final class CommentInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    private let commentTextView = InputTextView()
    private let postButton = UIButton(type: .system)
    private let divider = UIView()

    override var intrinsicContentSize: CGSize {
        return .zero
    }

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setAddTargets()
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func handlePostTapped() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    // MARK: - Helpers
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }

    private func setAddTargets() {
        postButton.addTarget(
            self,
            action: #selector(handlePostTapped),
            for: .touchUpInside
        )
    }

    // MARK: - UI

    private func setStyle() {
        backgroundColor = .white
        autoresizingMask = .flexibleHeight

        postButton.do {
            $0.setTitle("Post", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        }

        commentTextView.do {
            $0.placeholderText = "Enter comment.."
            $0.font = .systemFont(ofSize: 15)
            $0.isScrollEnabled = false
            $0.placeholderShouldCenter = true
        }

        divider.backgroundColor = .lightGray
    }

    private func setHierarchy() {
        addSubviews(postButton, commentTextView, divider)
    }

    private func setLayout() {
        postButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(-8)
            $0.size.equalTo(50)
        }

        commentTextView.snp.makeConstraints {
            $0.top.leading.equalTo(8)
            $0.trailing.equalTo(postButton.snp.leading).offset(-8)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
        }

        divider.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
