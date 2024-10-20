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

        let docRef = COLLECTION_NOTIFICATIONS
            .document(uid)
            .collection("user-notifications")
            .document()

        var data: [String: Any] = [
            "timestamp": Timestamp(date: Date()),
            "uid": currentUID,
            "type": type.rawValue,
            "id": docRef.documentID
        ]

        if let post = post {
            data["postID"] = post.postID
            data["postImageURL"] = post.imageURL
        }

        docRef.setData(data)
    }

    static func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        COLLECTION_NOTIFICATIONS
            .document(uid)
            .collection("user-notifications")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }

                let notifications = documents.map { Notification(dictionary: $0.data()) }
                completion(notifications)
            }
    }
}
