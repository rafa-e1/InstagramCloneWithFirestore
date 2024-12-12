//
//  ProfileCell.swift
//  Instagram
//
//  Created by RAFA on 5/18/24.
//

import UIKit

final class ProfileCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }

    private let postImageView = UIImageView()

    // MARK: - Helpers

    func configure() {
        guard let viewModel = viewModel else { return }
        
        postImageView.sd_setImage(with: viewModel.imageURL)
    }

    // MARK: - UI

    override func setStyle() {
        postImageView.do {
            $0.image = #imageLiteral(resourceName: "venom-7")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }

    override func setHierarchy() {
        addSubview(postImageView)
    }

    override func setLayout() {
        postImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
