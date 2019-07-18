//
//  ProfileViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/8/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

// See for counting label: https://github.com/sudeepag/SACountingLabel
//
class ProfileViewController: BaseFeedViewController
{
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var uploadPictureButton: UIButton!
    @IBOutlet weak var addCohortButton: UIButton!
    @IBOutlet weak var requestSentLabel: UILabel!
    @IBOutlet weak var youAreCohortsLabel: UILabel!
    @IBOutlet weak var totalAverageLabel: SACountingLabel!
    @IBOutlet weak var totalPercentLabel: UILabel!
    @IBOutlet weak var totalAverageCorrectLabel: UILabel!
    @IBOutlet weak var ownerAverageLabel: SACountingLabel!
    @IBOutlet weak var ownerPercentLabel: UILabel!
    @IBOutlet weak var ownerAverageCorrectLabel: UILabel!
    @IBOutlet weak var cohortAverageLabel: SACountingLabel!
    @IBOutlet weak var cohortPercentLabel: UILabel!
    @IBOutlet weak var cohortAverageCorrectLabel: UILabel!
    @IBOutlet weak var ownerAverageTitleLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var collapseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var profileDto: ProfileDto?
    var profileFeedStart: Int = 0
    var profileFeedQuantity: Int = 25
    var isProfileViewCollapsed: Bool = false
    var scrollInProcess: Bool = false
    var expandButtonPressedWhileScrolling: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set one-time styles
        profileImageView.layer.cornerRadius = 5
        addCohortButton.layer.cornerRadius = 3

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableViewRef = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let accountService = appManager.accountService
        if accountService.transferDoLoadProfile {
            loadProfile()
            
            // reset fields
            self.profileDto = nil
            Utils.hide(uiStackView: self.controlsStackView, uiView: self.addCohortButton)
            Utils.hide(uiStackView: self.controlsStackView, uiView: self.requestSentLabel)
            Utils.hide(uiStackView: self.controlsStackView, uiView: self.youAreCohortsLabel)
        }
 
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
    }
    
    func loadProfile() {
        SwiftSpinner.show("Loading profile...")
        //        print(Thread.isMainThread)
        let accountService = appManager.accountService
        
        if let transferUsername = accountService.transferUsername {
            accountService.resetTransfers()
            accountService.getProfile(profileUsername: transferUsername, completionHandler: { (response: Response<ProfileDto>) -> () in
                self.setProfileInfo(response: response)
                self.loadIntuitions()
                SwiftSpinner.hide()
            })
        } else {
            accountService.getProfile(completionHandler: { (response: Response<ProfileDto>) -> () in
                self.setProfileInfo(response: response)
                self.loadIntuitions()
                SwiftSpinner.hide()
            })
        }
    }

    override func loadIntuitions() {
        let intuitionService = appManager.intuitionService
        
        let username = profileDto?.userDto?.user?.username!
        
        intuitionService.fetchIntuitionsForProfileUser(username: username!, start: profileFeedStart, quantity: profileFeedQuantity) { (response: ResponseWithArray<IntuitionDto>) in
            let intuitionDtos = response.data!
            self.handleIntuitions(newIntuitions: intuitionDtos)
            SwiftSpinner.hide()
        }
    }
    
    func handleIntuitions(newIntuitions: [IntuitionDto]) {
        
        self.intuitionDtos.removeAll()
        
        // now reload data and close it out
        let intuitionService = appManager.intuitionService
        if case .ScrollToForIntuition? = intuitionService.transferAction {
            self.handleScrollTo(newIntuitions: newIntuitions)
        } else if case .ScrollToForOutcome? = intuitionService.transferAction {
            self.handleScrollTo(newIntuitions: newIntuitions)
        } else {
            self.intuitionDtos += newIntuitions
        }

        self.tableView.reloadData()
        intuitionService.resetTransfers()
    }
    
    private func handleScrollTo(newIntuitions: [IntuitionDto]) {
        let intuitionService = appManager.intuitionService
        let intuition = intuitionService.transferIntuition!
        // iterate through current intuitionDtos to find index
        var idx = 0
        for intuitionDto in newIntuitions {
            if intuition.id! == intuitionDto.intuition?.id! {
                break
            }
            idx += 1
        }
        
        // now do scroll to
        let indexPath = IndexPath(row: idx, section: 0)
        if case .ScrollToForIntuition? = intuitionService.transferAction {
            tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        } else if case .ScrollToForOutcome? = intuitionService.transferAction {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    
    @IBAction func uploadPictureButton_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func addCohortButton_TouchUpInside(_ sender: Any) {
        let consentUser = profileDto?.userDto!.user!
        let accountService = appManager.accountService
        accountService.addCohort(consentUser: consentUser!, completionHandler: { (response: Response<Void>) -> () in
            Utils.hide(uiStackView: self.controlsStackView, uiView: self.addCohortButton)
            Utils.show(uiStackView: self.controlsStackView, uiView: self.requestSentLabel, insertIndex: 1)
        })
    }
    
    @IBAction func collapseButtonToggle(_ sender: Any) {
        toggleCollapsableSection()
    }
    
    func toggleCollapsableSection() {
        if isProfileViewCollapsed {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                DispatchQueue.main.async {
                    self.collapseButton.imageView?.image = #imageLiteral(resourceName: "763-arrow-up-toolbar")
                }
                self.profileView.isHidden = false
                self.profileView.alpha = 1
            })
            if scrollInProcess {
                expandButtonPressedWhileScrolling = true
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.profileView.isHidden = true
                self.profileView.alpha = 0
                DispatchQueue.main.async {
                    self.collapseButton.imageView?.image = #imageLiteral(resourceName: "764-arrow-down-toolbar")
                }
            })
        }
        isProfileViewCollapsed = !isProfileViewCollapsed
    }
    
    @IBAction func settingsButtonTouched(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    private func setProfileInfo(response: Response<ProfileDto>) {
        // load profile info
        let profileDto = response.data!
        self.profileDto = profileDto
        let user = profileDto.userDto!.user!
        self.fullName.text = user.fullName
        if let userImageInfo = user.imageInfo {
            Utils.loadImage(sourceImageInfo: userImageInfo, targetImageView: self.profileImageView)
        } else {
            self.profileImageView.image = #imageLiteral(resourceName: "placeholderImg")
        }
        if !profileDto.owner! {
            Utils.hide(uiStackView: self.controlsStackView, uiView: self.uploadPictureButton)
        } else {
            Utils.show(uiStackView: self.controlsStackView, uiView: self.uploadPictureButton, insertIndex: 1)
        }
        
        // load averages
        self.setScoreOutlets(profileDto)
        if !profileDto.owner! {
            self.ownerAverageTitleLabel.text = "\(user.firstName!)'s Average"
        } else {
            self.ownerAverageTitleLabel.text = "Your Average"
        }
        
        // set outlets
        if profileDto.cohort! {
            Utils.show(uiStackView: self.controlsStackView, uiView: self.youAreCohortsLabel, insertIndex: 1)
        }
        // determine whether to show add cohort button
        let showAddCohort = profileDto.hasSession! && !profileDto.owner! && !(profileDto.userDto?.cohort!)!
        if showAddCohort {
            if !profileDto.cohortRequestSent! {
                Utils.show(uiStackView: self.controlsStackView, uiView: self.addCohortButton, insertIndex: 1)
            } else {
                Utils.show(uiStackView: self.controlsStackView, uiView: self.requestSentLabel, insertIndex: 1)
            }
        }
    }
    
    private func setScoreOutlets(_ profileDto: ProfileDto) {
        let scoreDto = profileDto.scoreDto!
        let score = scoreDto.score!
        
        totalAverageLabel.countFrom(fromValue: 0, to: Float(scoreDto.totalPercent!), withDuration: 2, andAnimationType: .EaseInOut, andCountingType: .Int)
        totalAverageCorrectLabel.text = "\(String(describing: scoreDto.totalCorrect!)) of \(String(describing: scoreDto.total!)) correct"
        setAveragesLabelColor(percent: scoreDto.totalPercent!, numberLabel: totalAverageLabel, percentLabel: totalPercentLabel, numCorrectLabel: totalAverageCorrectLabel)
        
        ownerAverageLabel.countFrom(fromValue: 0, to: Float(scoreDto.ownedPercent!), withDuration: 1, andAnimationType: .EaseOut, andCountingType: .Int)
        ownerAverageCorrectLabel.text = "\(score.ownedCorrect!.count) of \(String(describing: scoreDto.ownedTotal!)) correct"
        setAveragesLabelColor(percent: scoreDto.ownedPercent!, numberLabel: ownerAverageLabel, percentLabel: ownerPercentLabel, numCorrectLabel: ownerAverageCorrectLabel)
        
        cohortAverageLabel.countFrom(fromValue: 0, to: Float(scoreDto.cohortPercent!), withDuration: 1.5, andAnimationType: .EaseIn, andCountingType: .Int)
        cohortAverageCorrectLabel.text = "\(score.cohortCorrect!.count) of \(String(describing: scoreDto.cohortTotal!)) correct"
        setAveragesLabelColor(percent: scoreDto.cohortPercent!, numberLabel: cohortAverageLabel, percentLabel: cohortPercentLabel, numCorrectLabel: cohortAverageCorrectLabel)
    }
    
    private func setAveragesLabelColor(percent: Int, numberLabel: UILabel, percentLabel: UILabel, numCorrectLabel: UILabel) {
        let textColor = getAveragesLabelColor(percent)
        numberLabel.textColor = textColor
        percentLabel.textColor = textColor
        // Off for now
//        numCorrectLabel.textColor = textColor
    }
    
    private func getAveragesLabelColor(_ percent: Int) -> UIColor {
        var textColor = Constants.siContextualFailColor // default to red or fail
        if percent >= 50 {
            textColor = Constants.siContextualSuccessColor
        } else if percent >= 25 && percent < 50 {
            textColor = Constants.siContextualWarnColor
        }
        return textColor
    }
    
    override func postConfirmOutcome() {
        isProfileViewCollapsed = true
        let accountService = appManager.accountService
        accountService.getProfile(completionHandler: { (response: Response<ProfileDto>) -> () in
            self.toggleCollapsableSection()
            self.setProfileInfo(response: response)
        })
        
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                     UITableViewDataSource, UITableViewDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            SwiftSpinner.show("Uploading photo...")
            // upload photo if present
            let accountService = appManager.accountService
            accountService.upload(image: image, uploadCompletionHandler: { (response: Response<User>) ->
                () in
                self.profileImageView.image = image
                SwiftSpinner.hide()
            })
        }
        // this is causing viewWillAppear to fire, causing re-init
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intuitionDtos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntuitionCell2", for: indexPath) as! IntuitionCell2
        let intuitionDto = intuitionDtos[indexPath.row]
        cell.loadIntuitionDto(intuitionDto, intuitionTableView: tableView, baseFeedViewController: self, indexPath: indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollInProcess = true
        if !isProfileViewCollapsed && (!expandButtonPressedWhileScrolling) {
            DispatchQueue.main.async {
                self.profileView.isHidden = true
                self.profileView.alpha = 0
                self.collapseButton.imageView?.image = #imageLiteral(resourceName: "764-arrow-down-toolbar")
            }
            isProfileViewCollapsed = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollInProcess = false
        expandButtonPressedWhileScrolling = false
    }
}

