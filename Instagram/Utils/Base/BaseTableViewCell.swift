//
//  BaseTableViewCell.swift
//  Instagram
//
//  Created by RAFA on 12/2/24.
//

import UIKit

import SnapKit
import Then

class BaseTableViewCell: UITableViewCell {

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setStyle()
        setHierarch()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    func setStyle() {}
    func setHierarch() {}
    func setLayout() {}
}
