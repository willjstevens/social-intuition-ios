//
//  DeviceSession.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class DeviceSession: SiObject {
    var id: String?
    var userId: String?
    var deviceId: String?
    var httpSessionId: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "userId":
            userId = value as? String
        case "deviceId":
            deviceId = value as? String
        case "httpSessionId":
            httpSessionId = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
