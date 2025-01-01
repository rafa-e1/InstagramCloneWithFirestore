//
//  Post.swift
//  Instagram
//
//  Created by RAFA on 7/11/24.
//

import FirebaseFirestoreInternal

struct Post {
    
    let postID: String
    let ownerUID: String
    let ownerImageURL: String
    let ownerUsername: String
    let imageURL: String
    var likes: Int
    var caption: String
    let timestamp: Timestamp
    var didLike = false

    init(postID: String, dictionary: [String: Any]) {
        self.postID = postID
        self.ownerUID = dictionary["ownerUID"] as? String ?? ""
        self.ownerImageURL = dictionary["ownerImageURL"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.caption = dictionary["caption"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
