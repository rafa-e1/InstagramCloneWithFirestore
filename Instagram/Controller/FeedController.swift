//
//  FeedController.swift
//  Instagram
//
//  Created by RAFA on 5/15/24.
//

import UIKit

import FirebaseAuth

private let reuseIdentifier = "FeedCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        collectionView.register(
            FeedCell.self,
            forCellWithReuseIdentifier: reuseIdentifier
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(handleLogout)
        )
        
        navigationItem.title = "Feed"
    }
    
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 5
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! FeedCell
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}