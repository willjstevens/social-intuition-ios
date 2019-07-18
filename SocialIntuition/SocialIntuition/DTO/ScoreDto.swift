//
//  ScoreDto.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class ScoreDto: SiObject {
    var score: Score?
    var ownedPercent: Int? = -1
    var cohortPercent: Int? = -1
    var totalPercent: Int? = -1
    var total: Int? = -1
    var totalCorrect: Int? = -1
    var ownedTotal: Int? = -1
    var cohortTotal: Int? = -1
    var allOwned: [Intuition]? = []
    var allCohort: [Intuition]? = []
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "score":
            score = value as? Score
        case "ownedPercent":
            ownedPercent = value as? Int
        case "cohortPercent":
            cohortPercent = value as? Int
        case "totalPercent":
            totalPercent = value as? Int
        case "total":
            total = value as? Int
        case "totalCorrect":
            totalCorrect = value as? Int
        case "ownedTotal":
            ownedTotal = value as? Int
        case "cohortTotal":
            cohortTotal = value as? Int
        case "allOwned":
            allOwned = value as? [Intuition]
        case "allCohort":
            allCohort = value as? [Intuition]
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
