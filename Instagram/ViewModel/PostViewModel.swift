//
//  PostViewModel.swift
//  Instagram
//
//  Created by RAFA on 7/11/24.
//

import UIKit

struct PostViewModel {
    var post: Post

    var userProfileImageURL: URL? { return URL(string: post.ownerImageURL) }
    var username: String { return post.ownerUsername }
    
    var imageURL: URL? { return URL(string: post.imageURL) }
    var likes: Int { return post.likes }
    var likeButtonTintColor: UIColor { return post.didLike ? .systemRed : .black }
    var likeButtonImage: UIImage { return post.didLike ? #imageLiteral(resourceName: "like_selected") : #imageLiteral(resourceName: "like_unselected") }
    var caption: String { return post.caption }
    
    var likesLabelText: String {
        if post.likes == 1 {
            return "\(post.likes) like"
        } else {
            return "\(post.likes) likes"
        }
    }
    
    init(post: Post) {
        self.post = post
    }
}
