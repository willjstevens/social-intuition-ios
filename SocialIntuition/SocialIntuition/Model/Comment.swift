//
//  Comment.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class Comment: SiObject {
    var id: String?
    var commentText: String?
    var likes: [Like]? = []
    var insertTimestamp: String?
    var user: User?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "commentText":
            commentText = value as? String
        case "likes":
            likes = value as? [Like]
        case "insertTimestamp":
            insertTimestamp = value as? String
        case "user":
            user = value as? User
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
