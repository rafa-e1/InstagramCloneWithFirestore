//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by RAFA on 5/18/24.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStatusText(value: user.stats.posts, label: "posts")
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatusText(value: user.stats.followers, label: "followers")
    }
    
    var numberOfFollowing: NSAttributedString {
        return attributedStatusText(value: user.stats.following, label: "following")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStatusText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: "\(value)\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]
        )
        attributedText.append(
            NSAttributedString(
                string: label,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.lightGray
                ]
            )
        )
        return attributedText
    }
}
