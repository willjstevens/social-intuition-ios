//
//  DeviceLoginDto.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class DeviceLoginDto: SiObject {
    var user: User?
    var deviceSession: DeviceSession?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "user":
            user = value as? User
        case "deviceSession":
            deviceSession = value as? DeviceSession
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
