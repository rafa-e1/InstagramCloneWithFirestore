//
//  CommentCell.swift
//  Instagram
//
//  Created by RAFA on 7/12/24.
//

import UIKit

final class CommentCell: BaseCollectionViewCell {

    // MARK: - Properties

    var viewModel: CommentViewModel? {
        didSet { configure() }
    }

    private let profileImageView = UIImageView()
    private let commentLabel = UILabel()

    // MARK: - Helpers

    func configure() {
        guard let viewModel = viewModel else { return }

        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        commentLabel.attributedText = viewModel.commentLabelText()
    }

    // MARK: - UI

    override func setStyle() {
        profileImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 40 / 2
            $0.clipsToBounds = true
        }

        commentLabel.numberOfLines = 0
    }

    override func setHierarchy() {
        contentView.addSubviews(profileImageView, commentLabel)
    }

    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(8)
            $0.size.equalTo(40)
        }

        commentLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(-8)
        }
    }
}
