//
//  NotificationDto.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/30/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation

class NotificationDto: SiObject {
    var notification: Notification?
    var prettyTimestamp: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "notification":
            notification = value as? Notification
        case "prettyTimestamp":
            prettyTimestamp = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
