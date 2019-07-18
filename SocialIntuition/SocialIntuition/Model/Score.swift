//
//  Score.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class Score: SiObject {
    var userId: String?
    var ownedCorrect: [Intuition]? = []
    var ownedIncorrect: [Intuition]? = []
    var cohortCorrect: [Intuition]? = []
    var cohortIncorrect: [Intuition]? = []
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "userId":
            userId = value as? String
        case "ownedCorrect":
            ownedCorrect = value as? [Intuition]
        case "ownedIncorrect":
            ownedIncorrect = value as? [Intuition]
        case "cohortCorrect":
            cohortCorrect = value as? [Intuition]
        case "cohortIncorrect":
            cohortIncorrect = value as? [Intuition]

        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
