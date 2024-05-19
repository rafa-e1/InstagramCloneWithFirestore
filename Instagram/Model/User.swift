//
//  User.swift
//  Instagram
//
//  Created by RAFA on 5/18/24.
//

import Foundation

struct User {
    let email: String
    let fullname: String
    let profileImageURL: String
    let username: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        email = dictionary["email"] as? String ?? ""
        fullname = dictionary["fullname"] as? String ?? ""
        profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        username = dictionary["username"] as? String ?? ""
        uid = dictionary["uid"] as? String ?? ""
    }
}
