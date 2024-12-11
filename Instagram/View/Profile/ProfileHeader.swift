//
//  ProfileHeader.swift
//  Instagram
//
//  Created by RAFA on 5/18/24.
//

import UIKit

import SDWebImage
import SnapKit
import Then

protocol ProfileHeaderDelegate: AnyObject {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

final class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let editProfileFollowButton = UIButton(type: .system)
    private let postsLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    private let profileStatsStackView = UIStackView()
    private let topDividerView = UIView()
    private let gridButton = UIButton(type: .system)
    private let listButton = UIButton(type: .system)
    private let bookmarkButton = UIButton(type: .system)
    private let contentSwitchStackView = UIStackView()
    private let bottomDividerView = UIView()

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
    
    @objc func handleEditProfileFollowTapped() {
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        nameLabel.text = viewModel.fullname
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        postsLabel.attributedText = viewModel.numberOfPosts
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
    }

    private func setAddTargets() {
        editProfileFollowButton.addTarget(
            self,
            action: #selector(handleEditProfileFollowTapped),
            for: .touchUpInside
        )
    }

    // MARK: - UI

    private func setStyle() {
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .lightGray
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 80 / 2
        }

        nameLabel.font = .boldSystemFont(ofSize: 14)

        editProfileFollowButton.do {
            $0.setTitle("Loading", for: .normal)
            $0.layer.cornerRadius = 3
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.setTitleColor(.black, for: .normal)
        }

        [postsLabel, followersLabel, followingLabel].forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }

        profileStatsStackView.configureStackView(
            addArrangedSubviews: postsLabel, followersLabel, followingLabel,
            axis: .horizontal
        )

        gridButton.setImage(UIImage(named: "grid"), for: .normal)

        listButton.do {
            $0.setImage(UIImage(named: "list"), for: .normal)
            $0.tintColor = UIColor(white: 0, alpha: 0.2)
        }

        bookmarkButton.do {
            $0.setImage(UIImage(named: "ribbon"), for: .normal)
            $0.tintColor = UIColor(white: 0, alpha: 0.2)
        }

        contentSwitchStackView.configureStackView(
            addArrangedSubviews: gridButton, listButton, bookmarkButton,
            axis: .horizontal
        )

        [topDividerView, bottomDividerView].forEach {
            $0.backgroundColor = .lightGray
        }
    }

    private func setHierarchy() {
        addSubviews(
            profileImageView,
            nameLabel,
            profileStatsStackView,
            editProfileFollowButton,
            topDividerView,
            contentSwitchStackView,
            bottomDividerView
        )
    }

    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(12)
            $0.size.equalTo(80)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.leading.equalTo(profileImageView)
        }

        editProfileFollowButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        profileStatsStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(-12)
            $0.height.equalTo(50)
        }

        topDividerView.snp.makeConstraints {
            $0.top.equalTo(contentSwitchStackView.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }

        contentSwitchStackView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }

        bottomDividerView.snp.makeConstraints {
            $0.top.equalTo(contentSwitchStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
