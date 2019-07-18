//
//  OutcomeDto.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class OutcomeDto: SiObject {
    var outcome: Outcome?
    var owner: Bool? = false
    var predicted: Bool? = false
    var postPrettyTimestamp: String?
    var selfLikeDto: LikeDto?
    var likeDtos: [LikeDto]? = []
    var guestLikeDtos: [LikeDto]? = []
    var commentDtos: [CommentDto]? = []
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "outcome":
            outcome = value as? Outcome
        case "owner":
            owner = value as? Bool
        case "predicted":
            predicted = value as? Bool
        case "postPrettyTimestamp":
            postPrettyTimestamp = value as? String
        case "selfLikeDto":
            selfLikeDto = value as? LikeDto
        case "likeDtos":
            likeDtos = value as? [LikeDto]
        case "guestLikeDtos":
            guestLikeDtos = value as? [LikeDto]
        case "commentDtos":
            commentDtos = value as? [CommentDto]
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
