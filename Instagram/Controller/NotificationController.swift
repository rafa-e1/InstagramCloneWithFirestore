//
//  NotificationController.swift
//  Instagram
//
//  Created by RAFA on 5/15/24.
//

import UIKit

final class NotificationController: BaseViewController {

    // MARK: - Properties

    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }

    private let refresher = UIRefreshControl()
    private let tableView = UITableView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        setAddTargets()
        setDelegates()
        fetchNotifications()
    }

    // MARK: - Actions

    @objc private func handleRefresh() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }

    // MARK: - API

    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            print("DEBUG: Success call..\(notifications)")
            self.notifications = notifications
            self.checkIfUserIsFollowed()
        }
    }

    func checkIfUserIsFollowed() {
        notifications.forEach { notification in
            guard notification.type == .follow else { return }

            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(
                    where: {
                        $0.id == notification.id
                    }
                ) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }

    // MARK: - Helpers

    private func registerCells() {
        tableView.register(
            NotificationCell.self,
            forCellReuseIdentifier: NotificationCell.identifier
        )
    }

    private func setAddTargets() {
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UI

    override func setStyle() {
        navigationItem.title = "Notifications"

        tableView.do {
            $0.rowHeight = 80
            $0.separatorStyle = .none
            $0.refreshControl = refresher
        }
    }

    override func setHierarchy() {
        view.addSubview(tableView)
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource

extension NotificationController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return notifications.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self

        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)

        UserService.fetchUser(withUID: notifications[indexPath.row].uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {
    
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)

        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }

    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
        showLoader(true)

        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postID: String) {
        showLoader(true)

        PostService.fetchPost(withPostID: postID) { post in
            self.showLoader(false)
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
