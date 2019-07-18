//
//  IntuitionDto.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class IntuitionDto: SiObject {
    var intuition: Intuition?
    var owner: Bool? = false
    var interactive: Bool? = false
    var active: Bool? = false
    var correct: Bool? = false
    var canVote: Bool? = false
    var canContributeOutcome: Bool? = false
    var canMakeSocialContributions: Bool? = false
    var cohortVotedOutcomeDto: OutcomeDto?
    var selfLikeDto: LikeDto?
    var likeDtos: [LikeDto]? = []
    var guestLikeDtos: [LikeDto]? = []
    var commentDtos: [CommentDto]? = []
    var potentialOutcomeDtos: [OutcomeDto]? = []
    var outcomeDto: OutcomeDto?
    var postPrettyTimestamp: String?
    var expirationPrettyTimestamp: String?
    var postTimestamp: String?
    var expirationTimestamp: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "intuition":
            intuition = value as? Intuition
        case "owner":
            owner = value as? Bool
        case "interactive":
            interactive = value as? Bool
        case "active":
            active = value as? Bool
        case "correct":
            correct = value as? Bool
        case "canVote":
            canVote = value as? Bool
        case "canContributeOutcome":
            canContributeOutcome = value as? Bool
        case "canMakeSocialContributions":
            canMakeSocialContributions = value as? Bool
        case "cohortVotedOutcomeDto":
            cohortVotedOutcomeDto = value as? OutcomeDto
        case "selfLikeDto":
            selfLikeDto = value as? LikeDto
        case "likeDtos":
            likeDtos = value as? [LikeDto]
        case "guestLikeDtos":
            guestLikeDtos = value as? [LikeDto]
        case "commentDtos":
            commentDtos = value as? [CommentDto]
        case "potentialOutcomeDtos":
            potentialOutcomeDtos = value as? [OutcomeDto]
        case "outcomeDto":
            outcomeDto = value as? OutcomeDto
        case "postPrettyTimestamp":
            postPrettyTimestamp = value as? String
        case "expirationPrettyTimestamp":
            expirationPrettyTimestamp = value as? String
        case "postTimestamp":
            postTimestamp = value as? String
        case "expirationTimestamp":
            expirationTimestamp = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}


