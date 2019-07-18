//
//  StoredImageInfo.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class StoredImageInfo: SiObject {
    var fileName: String?
    var secureUrl: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "fileName":
            fileName = value as? String
        case "secureUrl":
            secureUrl = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
