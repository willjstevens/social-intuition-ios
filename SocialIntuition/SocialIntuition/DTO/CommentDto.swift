//
//  CommentDto.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class CommentDto: SiObject {
    var comment: Comment?
    var owner: Bool? = false
    var selfLikeDto: LikeDto?
    var likeDtos: [LikeDto]? = []
    var guestLikeDtos: [LikeDto]? = []
    var displayTimestamp: String?
    var postPrettyTimestamp: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "comment":
            comment = value as? Comment
        case "owner":
            owner = value as? Bool
        case "selfLikeDto":
            selfLikeDto = value as? LikeDto
        case "likeDtos":
            likeDtos = value as? [LikeDto]
        case "guestLikeDtos":
            guestLikeDtos = value as? [LikeDto]
        case "displayTimestamp":
            displayTimestamp = value as? String
        case "postPrettyTimestamp":
            postPrettyTimestamp = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
