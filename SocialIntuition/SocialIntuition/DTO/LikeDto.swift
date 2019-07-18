//
//  LikeDto.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class LikeDto: SiObject {
    var like: Like?
    var owner: Bool? = false
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "like":
            like = value as? Like
        case "owner":
            owner = value as? Bool
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
