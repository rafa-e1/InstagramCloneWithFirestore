//
//  User.swift
//  Instagram
//
//  Created by RAFA on 5/18/24.
//

import Foundation

import FirebaseAuth

struct User {
    let email: String
    let fullname: String
    let profileImageURL: String
    let username: String
    let uid: String
    
    var isFollowed = false
    var stats: UserStats!
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        email = dictionary["email"] as? String ?? ""
        fullname = dictionary["fullname"] as? String ?? ""
        profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
        stats = UserStats(followers: 0, following: 0)
    }
}

struct UserStats {
//    let posts: Int
    let followers: Int
    let following: Int
}
