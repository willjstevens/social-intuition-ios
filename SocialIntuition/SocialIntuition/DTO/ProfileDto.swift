//
//  ProfileDto.swift
//  SocialIntuition
//
//  Created by Will Stevens on 6/24/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation
//import EVReflection

class ProfileDto: SiObject {
    var userDto: UserDto?
    var scoreDto: ScoreDto?
    var owner: Bool? = false
    var cohort: Bool? = false
    var hasSession: Bool? = false
    var cohortRequestSent: Bool? = false
    var showCohortButtonSection: Bool? = false
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "userDto":
            userDto = value as? UserDto
        case "scoreDto":
            scoreDto = value as? ScoreDto
        case "owner":
            owner = value as? Bool
        case "cohort":
            cohort = value as? Bool
        case "hasSession":
            hasSession = value as? Bool
        case "cohortRequestSent":
            cohortRequestSent = value as? Bool
        case "showCohortButtonSection":
            showCohortButtonSection = value as? Bool
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
