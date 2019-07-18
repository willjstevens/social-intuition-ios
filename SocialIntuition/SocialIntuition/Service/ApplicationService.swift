//
//  ApplicationService.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/13/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


class ApplicationService
{
    var appManager: AppManager?
    var session: Session
    var httpClient: HttpClient
    var notificationBadgeCount: Int = 0
    var notificationsTimer: Timer?
    var notifications: [NotificationDto] = []
    var subscribers: [String: ((ResponseWithArray<NotificationDto>)->())] = [:]
    var currentResponse: (ResponseWithArray<NotificationDto>)?
    
    var transferShowWalkthrough: Bool = false
    
    init(_ session: Session, _ httpClient: HttpClient) {
        self.session = session
        self.httpClient = httpClient
    }

    func resetTransfers() {
        transferShowWalkthrough = false
    }
    
    func startNotifications() {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in }
        } else {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        }
        application.registerForRemoteNotifications()
        
        notificationsTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.pollForNotifications), userInfo: nil, repeats: true)
    }
    
    func stopNotifications() {
        notificationsTimer?.invalidate()
        subscribers.removeAll()
        currentResponse = nil
    }
    
    @objc func pollForNotifications() {
        fetchNotifications(completionHandler: { (response: ResponseWithArray<NotificationDto>) -> () in
            let refreshedNotificatins = response.data!
//            print(refreshedNotificatins)
            self.currentResponse = response
            self.notifications.removeAll()
            self.notifications.append(contentsOf: refreshedNotificatins)
            self.setBadgeIndicator(badgeCount: refreshedNotificatins.count)
            for (_, callback) in self.subscribers {
                callback(response)
            }
        })
    }
    
    func addSubscriber(key: String, callback: @escaping ((ResponseWithArray<NotificationDto>)->())) {
        subscribers[key] = callback
        // call immediately if present
        if let currentResp = currentResponse {
            callback(currentResp)
        }
    }
    
    func removeSubscriber(key: String) {
        subscribers.removeValue(forKey: key)
    }
    
    func checkEmailAvailability(email: String, completionHandler: @escaping ((Response<Void>)->())) {
        // get email availability
        httpClient.get("/search/email/" + email, completionHandler: { (response: Response<Void>) -> () in
            completionHandler(response)
        })
    }
    
    func checkUsernameAvailability(username: String, completionHandler: @escaping ((Response<Void>)->())) {
        // get email availability
        httpClient.get("/search/username/" + username, completionHandler: { (response: Response<Void>) -> () in
            completionHandler(response)
        })
    }
    
    func fetchNotifications(completionHandler: @escaping ((ResponseWithArray<NotificationDto>)->())) {
        let getUrl = "/notification"
        httpClient.getArray(getUrl, completionHandler: { (response: ResponseWithArray<NotificationDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func updateNotificationAsHandled(notification: Notification, completionHandler: @escaping ((Response<Void>)->())) {
        // post notification
        httpClient.post("/notification/handled", postBodyObject: notification, completionHandler: { (response: Response<Void>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func addFeedback(feedback: Feedback, completionHandler: @escaping ((Response<Void>)->())) {
        // post notification
        httpClient.post("/feedback", postBodyObject: feedback, completionHandler: { (response: Response<Void>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    
    // https://stackoverflow.com/questions/28011118/add-badge-to-app-icon-in-ios-8-with-swift
    func setBadgeIndicator(badgeCount: Int)
    {
        let application = UIApplication.shared

        let tabBarController = appManager?.tabBarController
        let notificationsTab = tabBarController?.tabBar.items?[3]

        if badgeCount == 0 {
            notificationsTab?.badgeValue = nil
            application.applicationIconBadgeNumber = 0
        } else {
            notificationsTab?.badgeValue = "\(badgeCount)"
            application.applicationIconBadgeNumber = badgeCount
        }
    }
    
    func navigateTo(tabBarTab: TabBarTab) {
        let tabBarController = self.appManager?.tabBarController
        tabBarController?.selectedIndex = tabBarTab.rawValue
    }

}
