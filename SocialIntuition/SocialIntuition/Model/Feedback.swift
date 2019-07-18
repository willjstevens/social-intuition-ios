//
//  Feedback.swift
//  SocialIntuition
//
//  Created by Will Stevens on 12/12/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation

class Feedback: SiObject {
    var id: String?
    var name: String?
    var email: String?
    var comment: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "name":
            name = value as? String
        case "email":
            email = value as? String
        case "comment":
            comment = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
