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
        setHierarchy()
        setLayout()
    }

    // MARK: - UI

    func setStyle() {
        view.backgroundColor = .white
    }

    func setHierarchy() {}
    func setLayout() {}
}
