//
//  PostService.swift
//  Instagram
//
//  Created by RAFA on 7/8/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestoreInternal

struct PostService {
    
    static func uploadPost(
        caption: String,
        image: UIImage,
        user: User,
        completion: @escaping(FirestoreCompletion)
    ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageURL in
            let data = [
                "ownerUID": uid,
                "ownerImageURL": user.profileImageURL,
                "ownerUsername": user.username,
                "imageURL": imageURL,
                "likes": 0,
                "caption": caption,
                "timestamp": Timestamp(date: Date())
            ] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS
            .order(by: "timestamp", descending: true)
            .getDocuments
        { snapshot, error in
            guard let documents =  snapshot?.documents else { return }
            
            let posts = documents.map({ Post(postID: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = COLLECTION_POSTS.whereField("ownerUID", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map({ Post(postID: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
}
