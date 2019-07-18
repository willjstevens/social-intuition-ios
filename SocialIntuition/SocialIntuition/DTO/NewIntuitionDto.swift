//
//  NewIntuitionDto.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/19/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation

class NewIntuitionDto: SiObject
{
    var defaultVisibility: String?
    var defaultPredictionType: String?
    var activeWindows: [ActiveWindow]? = []
    var predictionChoicesYesNo: [Outcome]? = []
    var predictionChoicesTrueFalse: [Outcome]? = []
    var scoreIntuition: Bool? = false
    var displayPrediction: Bool? = false
    var displayCohortsPredictions: Bool? = false
    var allowPredictedOutcomeVoting: Bool? = false
    var allowCohortsToContributePredictedOutcomes: Bool? = false
    
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "defaultVisibility":
            defaultVisibility = value as? String
        case "defaultPredictionType":
            defaultPredictionType = value as? String
        case "activeWindows":
            activeWindows = value as? [ActiveWindow]
        case "predictionChoicesYesNo":
            predictionChoicesYesNo = value as? [Outcome]
        case "predictionChoicesTrueFalse":
            predictionChoicesTrueFalse = value as? [Outcome]
        case "scoreIntuition":
            scoreIntuition = value as? Bool
        case "displayPrediction":
            displayPrediction = value as? Bool
        case "displayCohortsPredictions":
            displayCohortsPredictions = value as? Bool
        case "allowPredictedOutcomeVoting":
            allowPredictedOutcomeVoting = value as? Bool
        case "allowCohortsToContributePredictedOutcomes":
            allowCohortsToContributePredictedOutcomes = value as? Bool
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
