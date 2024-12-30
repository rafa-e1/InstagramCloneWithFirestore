//
//  ReusableIdentifier+.swift
//  Instagram
//
//  Created by RAFA on 12/2/24.
//

import UIKit

protocol ReusableIdentifier: AnyObject {}

extension ReusableIdentifier where Self: UIView {

    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableIdentifier {}
extension UITableViewCell: ReusableIdentifier {}
