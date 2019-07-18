//
//  UserDto.swift
//  SocialIntuition
//
//  Created by Will Stevens on 6/24/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation

class UserDto: SiObject {
    var user: User?
    var cohort: Bool? = false
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "user":
            user = value as? User
        case "cohort":
            cohort = value as? Bool
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}


