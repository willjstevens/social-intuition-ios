//
//  Outcome.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class Outcome: SiObject {
    var id: String?
    var predictionText: String?
    var isIntuitionOwnerContributed: Bool? = false
    var contributorUser: User?
    var isCorrect: Bool? = false
    var wrongByExpiration: Bool? = false
    var outcomeVoters: [User]? = []
    var likes: [Like]? = []
    var comments: [Comment]? = []
    var insertTimestamp: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "predictionText":
            predictionText = value as? String
        case "intuitionOwnerContributed":
            isIntuitionOwnerContributed = value as? Bool
        case "contributorUser":
            contributorUser = value as? User
        case "correct":
            isCorrect = value as? Bool
        case "wrongByExpiration":
            wrongByExpiration = value as? Bool
        case "outcomeVoters":
            outcomeVoters = value as? [User]
        case "likes":
            likes = value as? [Like]
        case "comments":
            comments = value as? [Comment]
        case "insertTimestamp":
            insertTimestamp = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
