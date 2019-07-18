//
//  Cohort.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/24/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation

class Cohort: SiObject {
    var id: String?
    var inviterUserId: String?
    var inviterFullName: String?
    var inviterUsername: String?
    var inviterImageInfo: StoredImageInfo?
    var consenterUserId: String?
    var consenterFullName: String?
    var consenterUsername: String?
    var consenterImageInfo: StoredImageInfo?
    var accepted: Bool? = false
    var ignored: Bool? = false
    var insertTimestamp: String?
    var updateTimestamp: String?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "inviterUserId":
            inviterUserId = value as? String
        case "inviterFullName":
            inviterFullName = value as? String
        case "inviterUsername":
            inviterUsername = value as? String
        case "inviterImageInfo":
            inviterImageInfo = value as? StoredImageInfo
        case "consenterUserId":
            consenterUserId = value as? String
        case "consenterFullName":
            consenterFullName = value as? String
        case "consenterUsername":
            consenterUsername = value as? String
        case "consenterImageInfo":
            consenterImageInfo = value as? StoredImageInfo
        case "accepted":
            accepted = value as? Bool
        case "ignored":
            ignored = value as? Bool
        case "insertTimestamp":
            insertTimestamp = value as? String
        case "updateTimestamp":
            updateTimestamp = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}

