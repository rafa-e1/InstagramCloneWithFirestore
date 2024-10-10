//
//  NotificationService.swift
//  Instagram
//
//  Created by RAFA on 10/10/24.
//

import FirebaseAuth
import FirebaseFirestoreInternal

struct NotificationService {

    static func uploadNotification(toUID uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUID else { return }

        var data: [String: Any] = [
            "timestamp": Timestamp(date: Date()),
            "uid": currentUID,
            "type": type.rawValue
        ]

        if let post = post {
            data["postID"] = post.postID
            data["postImageURL"] = post.imageURL
        }

        COLLECTION_NOTIFICATIONS
            .document(uid)
            .collection("user-notifications")
            .addDocument(data: data)
    }

    static func fetchNotifications() {
        
    }
}
