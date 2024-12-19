//
//  NotificationCell.swift
//  Instagram
//
//  Created by RAFA on 10/1/24.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost postID: String)
}

final class NotificationCell: BaseTableViewCell {

    // MARK: - Properties

    weak var delegate: NotificationCellDelegate?

    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }

    private let profileImageView = UIImageView()
    private let infoLabel = UILabel()
    private let postImageView = UIImageView()
    private let followButton = UIButton(type: .system)

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setAddTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func handlePostTapped() {
        guard let postID = viewModel?.notification.postID else { return }

        delegate?.cell(self, wantsToViewPost: postID)
    }

    @objc private func handleFollowTapped() {
        guard let viewModel = viewModel else { return }

        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, wantsToUnfollow: viewModel.notification.uid)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }
    }

    // MARK: - Helpers

    func configure() {
        guard let viewModel = viewModel else { return }

        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        postImageView.sd_setImage(with: viewModel.postImageURL)

        infoLabel.attributedText = viewModel.notificationMessage

        followButton.isHidden = !viewModel.shouldHidePostImage
        postImageView.isHidden = viewModel.shouldHidePostImage

        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }

    private func setAddTargets() {
        postImageView.addGestureRecognizer(
            UIGestureRecognizer(
                target: self,
                action: #selector(handlePostTapped)
            )
        )

        followButton.addTarget(
            self,
            action: #selector(handleFollowTapped),
            for: .touchUpInside
        )
    }

    // MARK: - UI

    override func setStyle() {
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 48 / 2
            $0.clipsToBounds = true
        }

        infoLabel.do {
            $0.font = .boldSystemFont(ofSize: 14)
            $0.numberOfLines = 0
        }

        postImageView.do {
            $0.backgroundColor = .lightGray
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }

        followButton.do {
            $0.setTitle("Loading", for: .normal)
            $0.layer.cornerRadius = 3
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.setTitleColor(.black, for: .normal)
        }
    }

    override func setHierarchy() {
        contentView.addSubviews(
            profileImageView,
            followButton,
            postImageView,
            infoLabel
        )
    }

    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(12)
            $0.size.equalTo(48)
        }

        followButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(-12)
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }

        postImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(-12)
            $0.size.equalTo(48)
        }

        infoLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(followButton.snp.leading).offset(-4)
        }
    }
}
