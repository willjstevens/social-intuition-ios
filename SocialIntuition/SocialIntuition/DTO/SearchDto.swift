//
//  SearchDto.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/17/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation

class SearchDto: SiObject {
    
    var requestingUserLoggedIn: Bool? = false
    var userResults: [UserDto]? = []
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "userResults":
            userResults = value as? [UserDto]
        case "requestingUserLoggedIn":
            requestingUserLoggedIn = value as? Bool
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
