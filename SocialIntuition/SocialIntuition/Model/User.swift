//
//  User.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/28/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class User: SiObject
{
    var id: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    var fullName: String?
    var imageInfo: StoredImageInfo?
    var email: String?
//    var birthdate: NSDate? // http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
    var gender: String?
    var password: String?
    var passwordQuestion: String?
    var passwordAnswer: String?
    var timezone: String?
    var cookieValue: String?
    var registrationSource: String?
    var verificationCode: String?
    var verificationCodeIssuedTimestamp: String?
    var verificationCodeCompletedTimestamp: String?
    var inAgreement: Bool? = false
    var guest: Bool? = false
    var unidentified: Bool? = false
    var enabled: Bool? = false
    var admin: Bool? = false
    var deleted: Bool? = false
    var insertTimestamp: String?

    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        switch key {
        case "id":
            id = value as? String
        case "username":
            username = value as? String
        case "firstName":
            firstName = value as? String
        case "lastName":
            lastName = value as? String
        case "fullName":
            fullName = value as? String
        case "imageInfo":
            imageInfo = value as? StoredImageInfo
        case "email":
            email = value as? String
        case "gender":
            gender = value as? String
        case "password":
            password = value as? String
        case "passwordQuestion":
            passwordQuestion = value as? String
        case "passwordAnswer":
            passwordAnswer = value as? String
        case "timezone":
            timezone = value as? String
        case "cookieValue":
            cookieValue = value as? String
        case "registrationSource":
            registrationSource = value as? String
        case "verificationCode":
            verificationCode = value as? String
        case "verificationCodeIssuedTimestamp":
            verificationCodeIssuedTimestamp = value as? String
        case "verificationCodeCompletedTimestamp":
            verificationCodeCompletedTimestamp = value as? String
        case "inAgreement":
            inAgreement = value as? Bool
        case "guest":
            guest = value as? Bool
        case "unidentified":
            unidentified = value as? Bool
        case "enabled":
            enabled = value as? Bool
        case "admin":
            admin = value as? Bool
        case "deleted":
            deleted = value as? Bool
        case "insertTimestamp":
            insertTimestamp = value as? String
        default:
            print("---> setValue for key '\(key)' should be handled.")
        }
    }
}
