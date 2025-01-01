//
//  Comment.swift
//  Instagram
//
//  Created by RAFA on 7/14/24.
//

import FirebaseFirestoreInternal

struct Comment {
    
    let uid: String
    let username: String
    let profileImageURL: String
    let timestamp: Timestamp
    let commentText: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictionary["comment"] as? String ?? ""
    }
}
