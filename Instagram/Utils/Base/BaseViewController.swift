//
//  BaseViewController.swift
//  Instagram
//
//  Created by RAFA on 12/2/24.
//

import UIKit

import SnapKit
import Then

class BaseViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setHierarch()
        setLayout()
    }

    // MARK: - UI

    func setStyle() {}
    func setHierarch() {}
    func setLayout() {}
}