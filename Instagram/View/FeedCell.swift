//
//  FeedCell.swift
//  Instagram
//
//  Created by RAFA on 5/15/24.
//

import UIKit

import SDWebImage

protocol FeedCellDelegate: AnyObject {
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String)
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post)
    func cell(_ cell: FeedCell, wantsToShare post: Post)
}

final class FeedCell: BaseCollectionViewCell {

    // MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: FeedCellDelegate?
    
    private let profileImageButton = UIButton(type: .system)
    private let usernameButton = UIButton(type: .system)
    let postImageView = UIImageView()
    let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let interactionButtonStackView = UIStackView()
    private let likesLabel = UILabel()
    private let captionLabel = UILabel()
    private let postTimeLabel = UILabel()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setAddTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func showUserProfile() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUID)
    }

    @objc func didTapLike() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, didLike: viewModel.post)
    }

    @objc private func didTapComments() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }

    @objc func didTapShare() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShare: viewModel.post)
    }

    // MARK: - Helpers
    
    private func configure() {
        guard let viewModel = viewModel else { return }

        profileImageButton.sd_setBackgroundImage(
            with: viewModel.userProfileImageURL,
            for: .normal
        )
        usernameButton.setTitle(viewModel.username, for: .normal)
        postImageView.sd_setImage(with: viewModel.imageURL)
        likesLabel.text = viewModel.likesLabelText
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        captionLabel.text = viewModel.caption
        postTimeLabel.text = viewModel.timestampString
    }

    private func setAddTargets() {
        profileImageButton.addTarget(
            self,
            action: #selector(showUserProfile),
            for: .touchUpInside
        )

        usernameButton.addTarget(
            self,
            action: #selector(showUserProfile),
            for: .touchUpInside
        )

        likeButton.addTarget(
            self,
            action: #selector(didTapLike),
            for: .touchUpInside
        )

        commentButton.addTarget(
            self,
            action: #selector(didTapComments),
            for: .touchUpInside
        )

        shareButton.addTarget(
            self,
            action: #selector(didTapShare),
            for: .touchUpInside
        )
    }

    // MARK: - UI

    override func setStyle() {
        backgroundColor = .white

        profileImageButton.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 40 / 2
            $0.backgroundColor = .lightGray
            $0.contentMode = .scaleAspectFill
        }

        usernameButton.do {
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 13)
        }

        postImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .lightGray
        }

        commentButton.do {
            $0.setImage(.comment, for: .normal)
            $0.tintColor = .black
        }

        shareButton.do {
            $0.setImage(.send, for: .normal)
            $0.tintColor = .black
        }

        interactionButtonStackView.configureStackView(
            addArrangedSubviews: likeButton, commentButton, shareButton,
            axis: .horizontal,
            distribution: .fillEqually
        )

        likesLabel.do {
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 13)
        }

        captionLabel.do {
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 14, weight: .medium)
        }

        postTimeLabel.do {
            $0.textColor = .lightGray
            $0.font = .systemFont(ofSize: 12)
        }
    }

    override func setHierarchy() {
        contentView.addSubviews(
            profileImageButton,
            usernameButton,
            postImageView,
            interactionButtonStackView,
            likesLabel,
            captionLabel,
            postTimeLabel
        )
    }

    override func setLayout() {
        profileImageButton.snp.makeConstraints {
            $0.top.leading.equalTo(12)
            $0.size.equalTo(40)
        }

        usernameButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageButton)
            $0.leading.equalTo(profileImageButton.snp.trailing).offset(8)
        }

        postImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(1)
        }

        interactionButtonStackView.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom)
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }

        likesLabel.snp.makeConstraints {
            $0.top.equalTo(interactionButtonStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }

        captionLabel.snp.makeConstraints {
            $0.top.equalTo(likesLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }

        postTimeLabel.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
    }
}
