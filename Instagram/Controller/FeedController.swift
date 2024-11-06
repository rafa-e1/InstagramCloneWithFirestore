//
//  FeedController.swift
//  Instagram
//
//  Created by RAFA on 5/15/24.
//

import UIKit

import FirebaseAuth

private let reuseIdentifier = "FeedCell"

final class FeedController: UICollectionViewController {
    
    // MARK: - Lifecycle
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }

    var post: Post? {
        didSet { collectionView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()

        if post != nil {
            checkIfUserLikedPosts()
        }
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = tabBarController as? MainTabBarController
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        } catch {
            // TODO: Alert View로 대체
            print("DEBUG: Failed to sign out")
        }
    }
    
    // MARK: - API
    
    func fetchPosts() {
        guard post == nil else { return }

        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPosts()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }

    func checkIfUserLikedPosts() {
        if let post = post {
            PostService.checkIfUserLikedPost(post: post) { didLike in
                self.post?.didLike = didLike
            }
        } else {
            self.posts.forEach { post in
                PostService.checkIfUserLikedPost(post: post) { didLike in
                    if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                        self.posts[index].didLike = didLike
                    }
                }
            }
        }
    }

    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        collectionView.register(
            FeedCell.self,
            forCellWithReuseIdentifier: reuseIdentifier
        )
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(handleLogout)
            )
        }
        
        navigationItem.title = "Feed"

        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? FeedCell else { return UICollectionViewCell() }
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {

    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUID: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = tabBarController as? MainTabBarController else { return }
        guard let user = tab.user else { return }

        cell.viewModel?.post.didLike.toggle()

        if post.didLike {
            PostService.unlikePost(post: post) { _ in
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { _ in
                cell.viewModel?.post.likes = post.likes + 1

                NotificationService.uploadNotification(
                    toUID: post.ownerUID,
                    fromUser: user,
                    type: .like,
                    post: post
                )
            }
        }
    }

    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }

    func cell(_ cell: FeedCell, wantsToShare post: Post) {
        guard let image = cell.postImageView.image else { return }

        let caption = cell.viewModel?.caption ?? ""
        let activityController = UIActivityViewController(
            activityItems: [caption, image],
            applicationActivities: nil
        )

        activityController.popoverPresentationController?.sourceView = cell

        present(activityController, animated: true)
    }
}
