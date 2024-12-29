//
//  CommentController.swift
//  Instagram
//
//  Created by RAFA on 7/12/24.
//

import UIKit

final class CommentController: BaseViewController {

    // MARK: - Properties

    private let post: Post
    private var comments = [Comment]()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()

    private let commentInputView = CommentInputAccessoryView()

    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: - Initializer

    init(post: Post) {
        self.post = post
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
        fetchComments()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - API

    func fetchComments() {
        CommentService.fetchComments(forPost: post.postID) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }

    // MARK: - Helpers

    private func registerCells() {
        collectionView.register(
            CommentCell.self,
            forCellWithReuseIdentifier: CommentCell.identifier
        )
    }

    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
        commentInputView.delegate = self
    }

    // MARK: - UI

    override func setStyle() {
        navigationItem.title = "Comments"

        collectionView.do {
            $0.backgroundColor = .white
            $0.alwaysBounceVertical = true
            $0.keyboardDismissMode = .interactive
        }
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

extension CommentController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return comments.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CommentCell.identifier,
            for: indexPath
        ) as? CommentCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CommentController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(withUID: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - CommentInputAccessoryViewDelegate

extension CommentController: CommentInputAccessoryViewDelegate {

    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        guard let tab = tabBarController as? MainTabBarController else { return }
        guard let currentUser = tab.user else { return }

        showLoader(true)

        CommentService.uploadComment(
            comment: comment,
            postID: post.postID,
            user: currentUser
        ) { error in
            self.showLoader(false)
            inputView.clearCommentTextView()

            NotificationService.uploadNotification(
                toUID: self.post.ownerUID,
                fromUser: currentUser,
                type: .comment,
                post: self.post
            )
        }
    }
}
