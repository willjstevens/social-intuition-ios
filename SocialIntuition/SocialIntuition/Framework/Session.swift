//
//  Session.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/31/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation

class Session {
    var user: User?
    var httpCient: HttpClient?
    var httpSessionId: String?
    var settings: Settings?
    
    var userId: String? {
        get {
            return self.settings?.getUserId()
        }
        set {
            if (newValue != nil) {
                settings?.saveUserId(value: newValue!)
            } else {
                settings?.saveUserId(value: "to-be-deleted")
            }
        }
    }
    
    var deviceId: String? {
        get {
            return self.settings?.getDeviceId()
        }
        set {
            if (newValue != nil) {
                settings?.saveDeviceId(value: newValue!)
            } else {
                settings?.saveDeviceId(value: "to-be-deleted")
            }
        }
    }
    
    func isUserIdInitialized () -> Bool {
        return (settings?.isUserIdInitialized())!
    }
    
    func isDeviceIdInitialized () -> Bool {
        return (settings?.isDeviceIdInitialized())!
    }
    
    func hasDeviceSession() -> Bool {
        return (settings?.isUserIdInitialized())! && (settings?.isDeviceIdInitialized())!
    }
    
    
    func setDeviceLoginInfo(_ deviceLoginDto: DeviceLoginDto) {
        user = deviceLoginDto.user
        if let deviceSession = deviceLoginDto.deviceSession {
            httpSessionId = deviceSession.httpSessionId
            userId = deviceSession.userId
            deviceId = deviceSession.deviceId
        }
    }
    
    func cleanup() {
        user = nil
        httpSessionId = nil
//        userId = nil
//        deviceId = nil
    
        settings?.removeUserId()
        settings?.removeDeviceId()
    }
}
