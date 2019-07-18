//
//  Notification.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/20/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation
import EVReflection

class Notification: SiObject {
    var id: String?
    var userId: String?
    var type: String?
    var message: String?
    var data: EVObject?
    var holdingData: NSDictionary?
    var isHandled: Bool? = false
    var insertTimestamp: String?

    override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> ()), encodeConverter: (() -> Any?))] {
        return [(
                key: "type"
                , decodeConverter: {
                    self.type = $0 as? String
                    if self.holdingData != nil {
                        self.convertData()
                    }
                }
                , encodeConverter: {
                    return self.type
                }
            ),
            (
                key: "data"
                , decodeConverter: {
                    self.holdingData = $0 as? NSDictionary
                    if self.type != nil {
                        self.convertData()
                    }
            }
                , encodeConverter: {
                    return self.data
            }
            )]
    }
    
    func convertData() {
        if self.type == "add-cohort" {
            self.data = Cohort(dictionary: self.holdingData!)
        } else if self.type == "invite-accepted" {
            self.data = Cohort(dictionary: self.holdingData!)
        } else if self.type == "outcome-set" {
            self.data = Intuition(dictionary: self.holdingData!)
        } else if self.type == "welcome" {
            self.data = User(dictionary: self.holdingData!)
        }
        self.holdingData = nil
    }
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "userId":
            userId = value as? String
        case "type":
            type = value as? String
        case "message":
            message = value as? String
        case "handled":
            isHandled = value as? Bool
        case "data":
            data = value as? EVObject
        case "insertTimestamp":
            insertTimestamp = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}

