//
//  NotificationsViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/8/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var noNotificationsLabel: UILabel!
    @IBOutlet weak var noNotificationsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let NOTIFICATIONS_VIEW_ID = "notifications-view"
    var notifications: [NotificationDto] = []
    var appManager = AppManager.appManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
        self.handleNotificationsReset()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        // register listener
        appManager.applicationService.addSubscriber(key: NOTIFICATIONS_VIEW_ID, callback: { (response: ResponseWithArray<NotificationDto>) -> () in
            let newNotifications = response.data!
            if self.areNotificationsDifferent(newNotificationDtos: newNotifications) {
                self.notifications.removeAll()
                self.notifications.append(contentsOf: newNotifications)
                self.tableView.reloadData()
                self.handleNotificationsReset()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        appManager.applicationService.removeSubscriber(key: NOTIFICATIONS_VIEW_ID)
    }
    
    // This comparison function will help eliminate the flashing on the view from full reloading every refresh
    func areNotificationsDifferent(newNotificationDtos: [NotificationDto]) -> Bool {
        var retval: Bool = false
        // NOTE: This concise code will not work due to Segmentation fault 11 at compile time in Swift 4
        //      See: https://stackoverflow.com/questions/40968517/command-failed-due-to-signal-segmentation-fault-11-while-emitting-ir-sil-funct
//        let oldNotificationIds = Set<String>(self.notifications.map {$0.notification?.id! })
//        let newNotificationIds = Set<String>(newNotificationDtos.map {$0.notification?.id! })
        
        // Do it the verbose way...
        var oldNotificationIds = Set<String>()
        for notificationDto in self.notifications {
            oldNotificationIds.insert((notificationDto.notification?.id!)!)
        }
        var newNotificationIds = Set<String>()
        for notificationDto in newNotificationDtos {
            newNotificationIds.insert((notificationDto.notification?.id!)!)
        }

        if oldNotificationIds != newNotificationIds {
            retval = true
        }
        return retval
    }
    
    func handleNotificationsReset() {
        if notifications.isEmpty {
            // hide table view
            Utils.hide(uiStackView: outerStackView, uiView: tableView)
            Utils.show(uiStackView: outerStackView, uiView: noNotificationsView, insertIndex: 0)
        } else {
            Utils.hide(uiStackView: outerStackView, uiView: noNotificationsView)
            Utils.show(uiStackView: outerStackView, uiView: tableView, insertIndex: 0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        let notification = notifications[indexPath.row]
        cell.loadNotification(notificationDto: notification, notificationsViewController: self)
        
        return cell
    }
}
