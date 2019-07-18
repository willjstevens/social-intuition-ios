//
//  ActiveWindow.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/27/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class ActiveWindow: SiObject {
    var code: String?
    var text: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "code":
            code = value as? String
        case "text":
            text = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
