//
//  Like.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class Like: SiObject {
    var id: String?
    var user: User?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "user":
            user = value as? User
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
