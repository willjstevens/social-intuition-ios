//
//  Intuition.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class Intuition: SiObject {
    var id: String?
    var user: User?
    var intuitionText: String?
    var visibility: String?
    var predictionType: String?
    var imageInfos: [StoredImageInfo]? = []
    var potentialOutcomes: [Outcome]? = []
    var predictedOutcome: Outcome?
    var outcome: Outcome?
    var scoreIntuition: Bool? = false
    var displayPrediction: Bool? = false
    var allowPredictedOutcomeVoting: Bool? = false
    var allowCohortsToContributePredictedOutcomes: Bool? = false
    var activeWindow: String?
    var likes: [Like]? = []
    var comments: [Comment]? = []
    var insertTimestamp: String?
    var expirationTimestamp: String?
    var expirationMillis: CLong? = -1
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "user":
            user = value as? User
        case "intuitionText":
            intuitionText = value as? String
        case "visibility":
            visibility = value as? String
        case "predictionType":
            predictionType = value as? String
        case "imageInfos":
            imageInfos = value as? [StoredImageInfo]
        case "potentialOutcomes":
            potentialOutcomes = value as? [Outcome]
        case "predictedOutcome":
            predictedOutcome = value as? Outcome
        case "outcome":
            outcome = value as? Outcome
        case "scoreIntuition":
            scoreIntuition = value as? Bool
        case "displayPrediction":
            displayPrediction = value as? Bool
        case "allowPredictedOutcomeVoting":
            allowPredictedOutcomeVoting = value as? Bool
        case "allowCohortsToContributePredictedOutcomes":
            allowCohortsToContributePredictedOutcomes = value as? Bool
        case "activeWindow":
            activeWindow = value as? String
        case "likes":
            likes = value as? [Like]
        case "comments":
            comments = value as? [Comment]
        case "insertTimestamp":
            insertTimestamp = value as? String
        case "expirationTimestamp":
            expirationTimestamp = value as? String
        case "expirationMillis":
            expirationMillis = value as? CLong
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
