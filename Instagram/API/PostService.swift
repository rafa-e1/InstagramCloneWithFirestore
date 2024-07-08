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
        completion: @escaping(FirestoreCompletion)
    ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageURL in
            let data = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageURL": imageURL,
                "ownerUID": uid
            ] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
}
