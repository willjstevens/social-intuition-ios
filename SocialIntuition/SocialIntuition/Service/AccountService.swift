//
//  AccountService.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/31/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation
import UIKit

class AccountService {
    var session: Session
    var httpClient: HttpClient
    var transferUsername: String?
    var transferDoLoadProfile: Bool = true
    
    init(_ session: Session, _ httpClient: HttpClient) {
        self.session = session
        self.httpClient = httpClient
    }
    
    func resetTransfers() {
        transferUsername = nil
        transferDoLoadProfile = true
    }
    
    func signup(_ email: String, _ username: String, _ password: String, _ firstName: String, _ lastName: String, signupCompletionHandler: @escaping ((Response<User>)->())) {
        let user = User()
        user.email = email
        user.username = username
        user.password = password
        user.firstName = firstName
        user.lastName = lastName
        user.inAgreement = true
        
        // post signup
        httpClient.post("/signup?src=sii", postBodyObject: user, completionHandler: { (signupResponse: Response<User>) -> () in
            
            signupCompletionHandler(signupResponse)
        })
    }
    
    func loginByUsernamePassword(_ username: String, _ password: String, loginCompletionHandler: @escaping ((Response<DeviceLoginDto>)->())) {
        let user = User()
        user.username = username
        user.password = password
        
        // assign a new deviceId on username/password login
        session.deviceId = UUID().uuidString
        
        // post login
        httpClient.post("/login", postBodyObject: user, completionHandler: { (response: Response<DeviceLoginDto>) -> () in
            
            // set session info into session
            self.session.setDeviceLoginInfo(response.data!)
            
            // start notifications
            AppManager.appManager.applicationService.startNotifications()
            
            // now call the view controller callback
            loginCompletionHandler(response)
        })
        
    }
    
    func loginByDeviceSession(loginCompletionHandler: @escaping ((Response<DeviceLoginDto>)->())) {

        // post login
        httpClient.post("/login/device-session", postBodyObject: nil, completionHandler: { (response: Response<DeviceLoginDto>) -> () in
            
            // set session info into session
            self.session.setDeviceLoginInfo(response.data!)
            
            // start notifications
            AppManager.appManager.applicationService.startNotifications()
            
            // now call the view controller callback
            loginCompletionHandler(response)
        })
    }
    
    func logout(logoutCompletionHandler: @escaping ((Response<Void>)->())) {
        // post login
        httpClient.post("/logout", postBodyObject: nil, completionHandler: { (response: Response<Void>) -> () in
            
            // set session info into session
            self.session.cleanup()
            
            // stop notifications now that logging out
            AppManager.appManager.applicationService.stopNotifications()
            
            // now call the view controller callback
            logoutCompletionHandler(response)
        })
    }
    
    func upload(image: UIImage, uploadCompletionHandler: @escaping ((Response<User>)->())) {
        // post upload
        httpClient.upload("/profile/photo", image: image, fileName: "profile.jpg", uploadCompletionHandler: { (response: Response<User>) -> () in
            
            // capture user here now including new image info details
            self.session.user = response.data
            
            // now call the view controller callback
            uploadCompletionHandler(response)
        })
    }
    
    func getProfile(completionHandler: @escaping ((Response<ProfileDto>)->())) {
        // get profile
        let username = session.user!.username!
        getProfile(profileUsername: username, completionHandler: { (response: Response<ProfileDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func getProfile(profileUsername: String, completionHandler: @escaping ((Response<ProfileDto>)->())) {
        // get profile
        let endpoint = "/profile/\(profileUsername)"
        httpClient.get(endpoint, completionHandler: { (response: Response<ProfileDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func addCohort(consentUser: User, completionHandler: @escaping ((Response<Void>)->())) {
        // add cohort
        httpClient.post("/cohort", postBodyObject: consentUser, completionHandler: { (response: Response<Void>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func acceptCohort(notification: Notification, completionHandler: @escaping ((Response<Void>)->())) {
        // accept cohort
        httpClient.post("/cohort/accept", postBodyObject: notification, completionHandler: { (response: Response<Void>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func ignoreCohort(notification: Notification, completionHandler: @escaping ((Response<Void>)->())) {
        // ignore cohort
        httpClient.post("/cohort/ignore", postBodyObject: notification, completionHandler: { (response: Response<Void>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func searchName(name: String, completionHandler: @escaping ((Response<SearchDto>)->())) {
        // get user name by name search strings
        var endpoint = ""
        // if something is in the search string then send it
        if !name.isEmpty {
            endpoint = "/search/name/\(name)"
        } else {
            // otherwise default to fetching all (a limit will be set on the server if none here)
            endpoint = "/users/all"
        }
        httpClient.get(endpoint, completionHandler: { (response: Response<SearchDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
}
