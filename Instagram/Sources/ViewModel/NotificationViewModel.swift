//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by RAFA on 10/24/24.
//

import UIKit

struct NotificationViewModel {
    
    var notification: Notification

    init(notification: Notification) {
        self.notification = notification
    }

    var profileImageURL: URL? { return URL(string: notification.userProfileImageURL) }
    var username: String? { return notification.username }
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        let attributedText = NSMutableAttributedString(
            string: username,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]
        )
        attributedText.append(
            NSAttributedString(
                string: message,
                attributes: [.font: UIFont.systemFont(ofSize: 14)]
            )
        )
        attributedText.append(
            NSAttributedString(
                string: " \(timestampString ?? " 2m")",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.lightGray
                ]
            )
        )

        return attributedText
    }

    var postImageURL: URL? { return URL(string: notification.postImageURL ?? "") }
    var shouldHidePostImage: Bool { return notification.type == .follow }
    var followButtonText: String { return notification.userIsFollowed ? "Following" : "Follow" }
    
    var followButtonBackgroundColor: UIColor {
        return notification.userIsFollowed ? .white : .systemBlue
    }

    var followButtonTextColor: UIColor {
        return notification.userIsFollowed ? .black : .white
    }

    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: notification.timestamp.dateValue(), to: Date())
    }
}
