//
//  NotificationTableViewCell.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/20/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var notificationIconImageView: UIImageView!
    @IBOutlet weak var notififationMessageLabel: UILabel!
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var outcomeSetButton: UIButton!
    @IBOutlet weak var addCohortStackView: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var inviteAcceptedButton: UIButton!
    @IBOutlet weak var addIntuitionButton: UIButton!
    
    
    private let appManager = AppManager.appManager
    private var notificationsViewController: NotificationsViewController?
    private var notification: Notification?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resetCell()
        
        // set view props
        userImageView.layer.cornerRadius = 3
        outcomeSetButton.layer.cornerRadius = 3
        acceptButton.layer.cornerRadius = 3
        ignoreButton.layer.cornerRadius = 3
        inviteAcceptedButton.layer.cornerRadius = 3
    }

    override func prepareForReuse() {
        resetCell()
    }
    
    func resetCell() {
        notification = nil
        userImageView.image = nil
        userFullName.text = ""
        notificationIconImageView.image = nil
        notififationMessageLabel.text = ""
    }
    
    func loadNotification(notificationDto: NotificationDto, notificationsViewController: NotificationsViewController) {
        self.notificationsViewController = notificationsViewController
        let notification = notificationDto.notification!
        self.notification = notification // this funky and forced
        notififationMessageLabel.text = notification.message
        displayTimeLabel.text = notificationDto.prettyTimestamp!
        
        let type = notification.type!
        if type == "add-cohort" {
            let cohort = notification.data as! Cohort
            userFullName.text = cohort.inviterFullName
            Utils.loadImage(sourceImageInfo: cohort.inviterImageInfo, targetImageView: userImageView)
            notificationIconImageView.image = #imageLiteral(resourceName: "779-users-toolbar")
            showAddCohortButtons()
        } else if type == "invite-accepted" {
            let cohort = notification.data as! Cohort
            userFullName.text = cohort.consenterFullName
            Utils.loadImage(sourceImageInfo: cohort.consenterImageInfo , targetImageView: userImageView)
            notificationIconImageView.image = #imageLiteral(resourceName: "777-thumbs-up-toolbar")
            showInviteAcceptedButton()
        } else if type == "outcome-set" {
            let intuition = notification.data as! Intuition
            userFullName.text = intuition.user?.fullName
            Utils.loadImage(sourceImageInfo: intuition.user?.imageInfo, targetImageView: userImageView)
            notificationIconImageView.image = #imageLiteral(resourceName: "724-info-toolbar")
            showOutcomeSetButton()
        } else if type == "welcome" {
            let user = notification.data as! User
            userFullName.text = user.fullName
            Utils.loadImage(sourceImageInfo: user.imageInfo, targetImageView: userImageView)
            notificationIconImageView.image = #imageLiteral(resourceName: "868-atom-toolbar")
            showAddIntuitionButton()
        }
    }

    private func showOutcomeSetButton() {
        clearButtonStackView()
        Utils.showByAdd(uiStackView: buttonStackView, uiView: outcomeSetButton)
    }
    
    private func showAddCohortButtons() {
        clearButtonStackView()
        Utils.showByAdd(uiStackView: buttonStackView, uiView: addCohortStackView)
    }
    
    private func showInviteAcceptedButton() {
        clearButtonStackView()
        Utils.showByAdd(uiStackView: buttonStackView, uiView: inviteAcceptedButton)
    }
    
    private func showAddIntuitionButton() {
        clearButtonStackView()
        Utils.showByAdd(uiStackView: buttonStackView, uiView: addIntuitionButton)
    }
    
    private func clearButtonStackView() {
        Utils.hide(uiStackView: buttonStackView, uiView: outcomeSetButton)
        Utils.hide(uiStackView: buttonStackView, uiView: addCohortStackView)
        Utils.hide(uiStackView: buttonStackView, uiView: inviteAcceptedButton)
        Utils.hide(uiStackView: buttonStackView, uiView: addIntuitionButton)
    }
    
    @IBAction func seeOutcomeButton(_ sender: Any) {
        let applicationService = self.appManager.applicationService
        applicationService.updateNotificationAsHandled(notification: self.notification!, completionHandler:  { (response: Response<Void>) in
            // transfer intuition over then tab over to activity feed
            let appManager = self.appManager
            appManager.intuitionService.transferIntuition = self.notification?.data as? Intuition
            appManager.intuitionService.transferAction = .ScrollToForOutcome
            appManager.applicationService.navigateTo(tabBarTab: .ActivityFeedTab)
        })
    }
    
    @IBAction func acceptCohortButton(_ sender: Any) {
        SwiftSpinner.show("Accepting cohort...")
        let accountService = appManager.accountService
        accountService.acceptCohort(notification: notification!, completionHandler:  { (response: Response<Void>) in
            let applicationService = self.appManager.applicationService
            applicationService.pollForNotifications()
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func ignoreCohortButton(_ sender: Any) {
        SwiftSpinner.show("Ignoring cohort...")
        let accountService = appManager.accountService
        accountService.ignoreCohort(notification: notification!, completionHandler:  { (response: Response<Void>) in
            let applicationService = self.appManager.applicationService
            applicationService.pollForNotifications()
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func visitProfileButton(_ sender: Any) {
        SwiftSpinner.show("Visiting profile...")
        let applicationService = self.appManager.applicationService
        applicationService.updateNotificationAsHandled(notification: notification!, completionHandler:  { (response: Response<Void>) in
            let cohort = self.notification?.data as! Cohort
            let accountService = self.appManager.accountService
            accountService.transferUsername = cohort.consenterUsername
            applicationService.navigateTo(tabBarTab: .ProfileTab)
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func addIntuitionButton(_ sender: Any) {
        SwiftSpinner.show("Loading...")
        let applicationService = self.appManager.applicationService
        applicationService.updateNotificationAsHandled(notification: notification!, completionHandler:  { (response: Response<Void>) in
            applicationService.navigateTo(tabBarTab: .AddIntuitionTab)
            SwiftSpinner.hide()
        })
    }
    
}
