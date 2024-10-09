//
//  Notification.swift
//  Instagram
//
//  Created by RAFA on 10/9/24.
//

import FirebaseFirestoreInternal

enum NotificationType: Int {
    case like, follow, comment

    var notificationMessage: String {
        switch self {
        case .like: return " liked your post."
        case .follow: return " started following you."
        case .comment: return " commented on your post."
        }
    }
}

struct Notification {
    let uid: String
    var postImageURL: String?
    var postID: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String

    init(dictionary: [String: Any]) {
        timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        id = dictionary["id"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
        postID = dictionary["postID"] as? String ?? ""
        postImageURL = dictionary["postImageURL"] as? String ?? ""
        type = NotificationType(rawValue: dictionary["timestamp"] as? Int ?? 0) ?? .like
    }
}
