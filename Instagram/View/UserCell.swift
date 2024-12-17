//
//  UserCell.swift
//  Instagram
//
//  Created by RAFA on 5/25/24.
//

import UIKit

final class UserCell: BaseTableViewCell {

    // MARK: - Properties
    
    var viewModel: UserCellViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let fullnameLabel = UILabel()
    private let nameStackView = UIStackView()
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
    }

    // MARK: - UI

    override func setStyle() {
        profileImageView.do {
            $0.layer.cornerRadius = 48 / 2
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .lightGray
            $0.image = #imageLiteral(resourceName: "venom-7")
        }

        usernameLabel.do {
            $0.font = .boldSystemFont(ofSize: 14)
        }

        fullnameLabel.do {
            $0.textColor = .lightGray
            $0.font = .systemFont(ofSize: 14)
        }

        nameStackView.configureStackView(
            addArrangedSubviews: usernameLabel, fullnameLabel,
            alignment: .leading,
            spacing: 4
        )
    }

    override func setHierarchy() {
        contentView.addSubviews(profileImageView, nameStackView)
    }

    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(12)
            $0.size.equalTo(48)
        }

        nameStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
    }
}
