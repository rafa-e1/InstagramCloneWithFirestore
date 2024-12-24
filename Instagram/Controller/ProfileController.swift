//
//  ProfileController.swift
//  Instagram
//
//  Created by RAFA on 5/15/24.
//

import UIKit

final class ProfileController: BaseViewController {

    // MARK: - Properties

    private var user: User
    private var posts = [Post]()

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Initializer

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        setDelegates()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
    }

    // MARK: - API

    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }

    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()

            print("DEBUG: \(stats)")
        }
    }

    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }

    // MARK: - Helpers

    private func registerCells() {
        collectionView.register(
            ProfileCell.self,
            forCellWithReuseIdentifier: ProfileCell.identifier
        )

        collectionView.register(
            ProfileHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeader.identifier
        )
    }

    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - UI

    override func setStyle() {
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
    }

    override func setHierarchy() {
        view.addSubview(collectionView)
    }

    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return posts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCell.identifier,
            for: indexPath
        ) as? ProfileCell else {
            return UICollectionViewCell()
        }

        cell.viewModel = PostViewModel(post: posts[indexPath.row])

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeader.identifier,
            for: indexPath
        ) as? ProfileHeader else { return UICollectionReusableView() }

        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)

        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {

    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        guard let tab = tabBarController as? MainTabBarController else { return }
        guard let currentUser = tab.user else { return }

        if user.isCurrentUser {
            print("DEBUG: Show edit profile here..")
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { error in
                self.user.isFollowed = false
                self.collectionView.reloadData()

                PostService.updateUserFeedAfterFollowing(user: user, didFollow: false)
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowed = true
                self.collectionView.reloadData()

                NotificationService.uploadNotification(
                    toUID: user.uid,
                    fromUser: currentUser,
                    type: .follow
                )

                PostService.updateUserFeedAfterFollowing(user: user, didFollow: true)
            }
        }
    }
}
