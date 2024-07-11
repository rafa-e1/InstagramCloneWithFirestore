//
//  Post.swift
//  Instagram
//
//  Created by RAFA on 7/11/24.
//

import FirebaseFirestoreInternal

struct Post {
    var caption: String
    var likes: Int
    let imageURL: String
    let ownerUID: String
    let timestamp: Timestamp
    let postID: String
    
    init(postID: String, dictionary: [String: Any]) {
        self.postID = postID
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUID = dictionary["ownerUID"] as? String ?? ""
    }
}
