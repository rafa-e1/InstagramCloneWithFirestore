//
//  BaseCollectionViewCell.swift
//  Instagram
//
//  Created by RAFA on 12/2/24.
//

import UIKit

import SnapKit
import Then

class BaseCollectionViewCell: UICollectionViewCell {

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyle()
        setHierarch()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private func setStyle() {}
    private func setHierarch() {}
    private func setLayout() {}
}
