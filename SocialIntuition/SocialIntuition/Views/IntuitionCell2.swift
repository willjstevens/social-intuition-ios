//
//  IntuitionCell2.swift
//  SocialIntuition
//
//  Created by Will Stevens on 7/25/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

class IntuitionCell2: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var cellContentStackView: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var visibilityIconImageView: UIImageView!
    @IBOutlet weak var postPrettyTime: UILabel!
    @IBOutlet weak var expirationPrettyTime: UILabel!
    @IBOutlet weak var intuitionTextView: UIView!
    @IBOutlet weak var intuitionText: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var intuitionImageView: UIImageView!
    @IBOutlet weak var predictedOutcomeOuterView: UIView!
    @IBOutlet weak var addAnOutcomeTextField: UITextField!
    @IBOutlet weak var predictedOutcomeListView: UIView!
    @IBOutlet weak var predictedOutcomeLabel: UILabel!
    @IBOutlet weak var predictedOutcomeListStackView: UIStackView!
    @IBOutlet weak var predictionOutcomesStackView: UIStackView!
    @IBOutlet weak var outcomeSeparatorLineView: UIView!
    @IBOutlet weak var outcomeOuterView: UIView!
    @IBOutlet weak var outcomeView: UIView!
    @IBOutlet weak var outcomeStackView: UIStackView!
    @IBOutlet weak var outcomeResultLabel: UILabel!
    @IBOutlet weak var correctOutcomeLabel: UILabel!
    @IBOutlet weak var wrongOutcomeStackView: UIStackView!
    @IBOutlet weak var actualLabel: UILabel!
    @IBOutlet weak var actualResult: UILabel!
    @IBOutlet weak var predictedResult: UILabel!
    @IBOutlet weak var predictedLabel: UILabel!
    @IBOutlet weak var predictedOutcomeOuterStackView: UIStackView!
    @IBOutlet weak var wrongOutcomeHorizontalStackView: UIStackView!
    @IBOutlet weak var wrongOutcomeLabelColumnStackView: UIStackView!
    @IBOutlet weak var wrongOutcomeValueColumnStackView: UIStackView!
    @IBOutlet weak var setOutcomeButton: UIButton!
    @IBOutlet weak var selectOutcomeLabel: UILabel!
    @IBOutlet weak var selectOutcomeButton: UIButton!
    @IBOutlet weak var potentialOutcomesPickerView: UIPickerView!
    @IBOutlet weak var confirmOutcomeButton: UIButton!
    @IBOutlet weak var cancelOutcomeButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var socialBarStackView: UIStackView!
    @IBOutlet weak var footerStackView: UIStackView!
    @IBOutlet weak var confirmDeleteButton: UIButton!
    @IBOutlet weak var cancelDeleteButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var appManager = AppManager.appManager
    private var intuitionDto: IntuitionDto = IntuitionDto()
    private var intuition: Intuition = Intuition()
    private var user: User = User()
    private var intuitionImageInfo: StoredImageInfo?
    private var selectedOutcome: Outcome?
    private var intuitionTableView: UITableView?
    private var baseFeedViewController: BaseFeedViewController?
    private var activeContentStackViewOffset: Int = 0
    private var indexPath: IndexPath?
    
    var getIntuitionDto: IntuitionDto {
        get { return intuitionDto }
    }
    
    func loadIntuitionDto(_ intuitionDto: IntuitionDto) {
        self.loadIntuitionDto(intuitionDto, intuitionTableView: intuitionTableView!, baseFeedViewController: baseFeedViewController!, indexPath: indexPath!)
        baseFeedViewController?.updateIntuitionDto(intuitionDto: intuitionDto, indexPath: self.indexPath!)
    }
    
    func loadIntuitionDto(_ intuitionDto: IntuitionDto, intuitionTableView: UITableView, baseFeedViewController: BaseFeedViewController, indexPath: IndexPath) {
        self.intuitionTableView = intuitionTableView
        self.baseFeedViewController = baseFeedViewController
        self.indexPath = indexPath
        
        setMainFields(intuitionDto)
        setOutlets()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    // Should this be called from override prepare for reuse???
    func resetCell() {
        
        // reset optional fields; required fields will be overwritten
        intuitionImageInfo = nil
        activeContentStackViewOffset = 0
        
        // reset outlets
        userImageView.image = #imageLiteral(resourceName: "placeholderImg")
        intuitionImageView.image = nil
        
        Utils.hide(uiStackView: cellContentStackView, uiView: intuitionImageView)
        
        // Predictes view resets
        resetSetOutcomeControls()
        Utils.hide(uiStackView: predictedOutcomeListStackView, uiView: addAnOutcomeTextField)

        // Outcome view resets
        Utils.hide(uiStackView: cellContentStackView, uiView: outcomeOuterView)
        Utils.hide(uiStackView: cellContentStackView, uiView: predictedOutcomeOuterView)
        if (!predictionOutcomesStackView.arrangedSubviews.isEmpty) {
            Utils.clearStackView(uiStackView: predictionOutcomesStackView)
        }
        
        // setup delete functionality
        Utils.hide(uiStackView: socialBarStackView, uiView: deleteButton)
        Utils.hide(uiStackView: footerStackView, uiView: confirmDeleteButton)
        Utils.hide(uiStackView: footerStackView, uiView: cancelDeleteButton)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
        setViewStyles()
    }

    private func setViewStyles() {
        userImageView.layer.cornerRadius = 2
        deleteButton.layer.cornerRadius = 2
        confirmDeleteButton.layer.cornerRadius = 2
        cancelDeleteButton.layer.cornerRadius = 2
        
        // Prediction View
        predictedOutcomeListView.layer.borderWidth = 0.6
        predictedOutcomeListView.layer.cornerRadius = 2
        predictedOutcomeListView.layer.borderColor = UIColor.lightGray.cgColor
        addAnOutcomeTextField.delegate = self
        potentialOutcomesPickerView.dataSource = self
        potentialOutcomesPickerView.delegate = self
        setOutcomeButton.layer.cornerRadius = 2
        confirmOutcomeButton.layer.cornerRadius = 2
        cancelOutcomeButton.layer.cornerRadius = 2
        
        // Outcome View
        outcomeView.layer.borderWidth = 0.6
        outcomeView.layer.cornerRadius = 2
    }
    
    private func setMainFields(_ intuitionDto: IntuitionDto) {
        self.intuitionDto = intuitionDto
        self.intuition = intuitionDto.intuition! // should always be an intuition
        self.user = intuition.user! // should always be a user
        
        // intuition image field is optional
        if let imageInfo = intuition.imageInfos, intuition.imageInfos!.count >= 1 {
            self.intuitionImageInfo = imageInfo[0] // for now, only one image is supported so take the first
            Utils.show(uiStackView: cellContentStackView, uiView: intuitionImageView, insertIndex: 2)
            activeContentStackViewOffset += 1
        }
        
        // TODO: REMOVE ME LATER WHEN IOS BUG IS FIXED
        let intuitionService = appManager.intuitionService
        intuitionService.transferIntuitionDto = self.intuitionDto
        intuitionService.transferIntuitionCell = self
    }
    
    private func setOutlets() {
        if let userImageInfo = user.imageInfo {
            Utils.loadImage(sourceImageInfo: userImageInfo, targetImageView: userImageView)
        }
        userFullName.text = user.fullName
        visibility.text = Visibility.toLabel(intuition.visibility!)
        postPrettyTime.text = "Posted \(intuitionDto.postPrettyTimestamp!)"
        
        intuitionText.text = intuition.intuitionText
        author.text = "- \(user.fullName!)"
        
        switch intuition.visibility! {
        case Visibility.Public.key:
            visibilityIconImageView.image = #imageLiteral(resourceName: "745-unlocked-toolbar")
        case Visibility.Cohort.key:
            visibilityIconImageView.image = #imageLiteral(resourceName: "895-user-group-toolbar")
        case Visibility.Private.key:
            visibilityIconImageView.image = #imageLiteral(resourceName: "744-locked-toolbar")
        default:
            visibilityIconImageView.image = #imageLiteral(resourceName: "745-unlocked-toolbar")
        }
        
        if intuitionImageInfo != nil {
            Utils.loadImage(sourceImageInfo: intuitionImageInfo, targetImageView: intuitionImageView)
        }
        
        let allowSetOutcome = intuitionDto.active! && intuitionDto.owner!
        if allowSetOutcome {
            Utils.showByAdd(uiStackView: predictedOutcomeOuterStackView, uiView: setOutcomeButton)
        } else {
            Utils.hide(uiStackView: predictedOutcomeOuterStackView, uiView: setOutcomeButton)
        }
        
        // Note on content index:
        //
        // 2 is the default index location of the active-deciding index, Either:
        //      1. prediction view if intuition is still active 
        //      2. outcome view if intuition is inactive because outcome is set
        //
        // activeContentStackViewOffset is an offset in case other factors like the intuition image view is set
        //
        let contentInsertIdx = 2 + activeContentStackViewOffset
        
        /*
         * Prediction View
         */
        if intuitionDto.active! {
            Utils.show(uiStackView: cellContentStackView, uiView: predictedOutcomeOuterView, insertIndex: contentInsertIdx)
            
            if intuition.displayPrediction! {
                predictedOutcomeLabel.text = intuitionDto.intuition?.predictedOutcome?.predictionText
            } else {
                predictedOutcomeLabel.text = PredictionType.toLabel(intuition.predictionType!)
            }
    
            if intuitionDto.canContributeOutcome! {
                Utils.showByAdd(uiStackView: predictedOutcomeListStackView, uiView: addAnOutcomeTextField)
            }
            
        
            if (!predictionOutcomesStackView.arrangedSubviews.isEmpty) {
                Utils.clearStackView(uiStackView: predictionOutcomesStackView)
            }
            
            for idx in 1...intuitionDto.potentialOutcomeDtos!.count {
                let predictionView = PredictionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                predictionView.loadOutcomeDto(intuitionDto: intuitionDto, idx: idx, intuitionCell: self, baseFeedViewController: baseFeedViewController!)
                predictionOutcomesStackView.addArrangedSubview(predictionView)
            }

            expirationPrettyTime.text = "Expires \(intuitionDto.expirationPrettyTimestamp!)"
        }
        
        /*
         * Outcome View
         */
        if !intuitionDto.active! {
            expirationPrettyTime.text = "Outcome Set"

            Utils.show(uiStackView: cellContentStackView, uiView: outcomeOuterView, insertIndex: contentInsertIdx)
        
            if intuitionDto.correct! {
                outcomeResultLabel.text = "CORRECT"
                outcomeResultLabel.textColor = Constants.siContextualSuccessColor
                outcomeView.layer.borderColor = Constants.siContextualSuccessColor.cgColor
            } else {
                outcomeResultLabel.text = "WRONG"
                outcomeResultLabel.textColor = Constants.siContextualFailColor
                outcomeView.layer.borderColor = Constants.siContextualFailColor.cgColor
            }
            
            if intuition.outcome!.isCorrect! {
                Utils.showByAdd(uiStackView: outcomeStackView, uiView: correctOutcomeLabel)
                correctOutcomeLabel.text = intuition.outcome?.predictionText
                outcomeSeparatorLineView.backgroundColor = Constants.siContextualSuccessColor
                
                // since correct, hide the wrong view stuff
                Utils.hide(uiStackView: wrongOutcomeLabelColumnStackView, uiView: predictedLabel)
                Utils.hide(uiStackView: wrongOutcomeLabelColumnStackView, uiView: actualLabel)
                Utils.hide(uiStackView: wrongOutcomeValueColumnStackView, uiView: predictedResult)
                Utils.hide(uiStackView: wrongOutcomeValueColumnStackView, uiView: actualResult)
                Utils.hide(uiStackView: outcomeStackView, uiView: wrongOutcomeStackView)
            } else {
                // since correct, hide the wrong view stuff
                Utils.showByAdd(uiStackView: wrongOutcomeLabelColumnStackView, uiView: actualLabel)
                Utils.showByAdd(uiStackView: wrongOutcomeLabelColumnStackView, uiView: predictedLabel)
                Utils.showByAdd(uiStackView: wrongOutcomeValueColumnStackView, uiView: actualResult)
                Utils.showByAdd(uiStackView: wrongOutcomeValueColumnStackView, uiView: predictedResult)
                Utils.showByAdd(uiStackView: outcomeStackView, uiView: wrongOutcomeStackView)
                
                predictedResult.text = intuition.predictedOutcome?.predictionText
         
                if intuitionDto.intuition!.outcome!.wrongByExpiration! {
                    actualResult.text = "No outcome entered before expiration"
                } else {
                    actualResult.text = intuition.outcome?.predictionText
                }
                outcomeSeparatorLineView.backgroundColor = Constants.siContextualFailColor
                
                // since wrong, hide the correct view stuff
                Utils.hide(uiStackView: outcomeStackView, uiView: correctOutcomeLabel)
            }
        }
        
        updateSocialBar()
        
        if intuitionDto.owner! {
            Utils.showByAdd(uiStackView: socialBarStackView, uiView: deleteButton)
        }
    }
    
    func updateTable() {
        intuitionTableView?.beginUpdates()
        intuitionTableView?.endUpdates()
    }
    
    private func hasIntuitionImage() -> Bool {
        return self.intuitionImageInfo != nil
    }
    
    @IBAction func addOutcomeTextField_EditingDidBegin(_ sender: Any) {
        intuitionTableView?.scrollToView(view: addAnOutcomeTextField, animated: true)
    }
    
    @IBAction func setOutcomeButton_TouchUpInside(_ sender: Any) {
        Utils.hide(uiStackView: predictedOutcomeOuterStackView, uiView: setOutcomeButton)
        Utils.animatedShow(uiStackView: predictedOutcomeOuterStackView, uiView: selectOutcomeLabel, insertIndex: 1)
        Utils.animatedShow(uiStackView: predictedOutcomeOuterStackView, uiView: selectOutcomeButton, insertIndex: 2)
        Utils.animatedShow(uiStackView: predictedOutcomeOuterStackView, uiView: cancelOutcomeButton, insertIndex: 3)
        
//        let tableView = self.baseFeedViewController?.tableViewRef
//        tableView!.scrollByPoints(tableView: tableView!, points: 900, isUp: true)
        
        updateTable()
    }
    
    @IBAction func selectOutcomeButton_TouchUpInside(_ sender: Any) {
        Utils.animatedShow(uiStackView: predictedOutcomeOuterStackView, uiView: potentialOutcomesPickerView, insertIndex: 4)
        updateTable()
    }
    
    @IBAction func confirmOutcomeButton_TouchUpInside(_ sender: Any) {
        SwiftSpinner.show("Setting outcome")
        let intuitionService = appManager.intuitionService
        intuitionService.setOutcome(selectedOutcome!, intuitionId: intuition.id!, completionHandler:  { (response: Response<IntuitionDto>) in
            let intuitionDto = response.data!
            self.resetCell()
            self.loadIntuitionDto(intuitionDto)
            self.resetSetOutcomeControls()
            self.updateTable()
            self.baseFeedViewController?.postConfirmOutcome()
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func cancelOutcomeButton_TouchUpInside(_ sender: Any) {
        Utils.animate {
            self.resetSetOutcomeControls()
            Utils.showByAdd(uiStackView: self.predictedOutcomeOuterStackView, uiView: self.setOutcomeButton)
            self.updateTable()
        }
    }
    
    @IBAction func likesButton_TouchUpInside(_ sender: Any) {
        let intuitionService = appManager.intuitionService
        if intuitionDto.selfLikeDto == nil {
            SwiftSpinner.show("Liking...")
            // not liked so make it like option
            intuitionService.addLike(intuitionId: intuition.id!, completionHandler:  { (response: Response<IntuitionDto>) in
                let intuitionDto = response.data!
                self.resetCell()
                self.loadIntuitionDto(intuitionDto)
                SwiftSpinner.hide()
            })
        } else {
            // already liked so remove it
            intuitionService.removeLike(intuitionDto.selfLikeDto!.like!, completionHandler:  { (response: Response<IntuitionDto>) in
                SwiftSpinner.show("Unliking...")
                let intuitionDto = response.data!
                self.resetCell()
                self.loadIntuitionDto(intuitionDto)
                SwiftSpinner.hide()
            })
        }
    }
    
    @IBAction func likeCountButton_TouchUpInside(_ sender: Any) {
        // NOTE: need to do this hack due to broken segue prepare not being called
        //      Bug filed: https://bugreport.apple.com/web/?problemID=32746982
        //        homeViewController!.performSegue(withIdentifier: "likeSegue", sender: self)
        
        let intuitionService = appManager.intuitionService
        intuitionService.transferIntuitionDto = self.intuitionDto
        intuitionService.transferIntuitionCell = self
        intuitionService.transferLevel = "intuition"
        
        baseFeedViewController?.performSegue(withIdentifier: "likeSegue", sender: nil)
    }
    
    @IBAction func commentsButton_TouchUpInside(_ sender: Any) {
        // NOTE: need to do this hack due to broken segue prepare not being called
        //      Bug filed: https://bugreport.apple.com/web/?problemID=32746982
        //        homeViewController!.performSegue(withIdentifier: "commentSegue", sender: self)
        
        let intuitionService = appManager.intuitionService
        intuitionService.transferIntuitionDto = self.intuitionDto
        intuitionService.transferIntuitionCell = self
        intuitionService.transferLevel = "intuition"
        
        baseFeedViewController?.performSegue(withIdentifier: "commentSegue", sender: nil)
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [intuition.intuitionText!, intuitionImageView],
                                                          applicationActivities: nil)
        baseFeedViewController!.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        Utils.hide(uiStackView: socialBarStackView, uiView: deleteButton)
        Utils.showByAdd(uiStackView: footerStackView, uiView: confirmDeleteButton)
        Utils.showByAdd(uiStackView: footerStackView, uiView: cancelDeleteButton)
//        intuitionTableView?.scrollToView(view: author, animated: true)
        updateTable()
    }
    
    @IBAction func confirmDeleteButton(_ sender: Any) {
        SwiftSpinner.show("Removing intuition...")
        let intuitionService = appManager.intuitionService
        intuitionService.removeIntuition(intuition, completionHandler:  { (response: Response<IntuitionDto>) in
            let indexPath = IndexPath(row: 0, section: 0)
            self.intuitionTableView?.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
            // reload all
            self.baseFeedViewController?.loadIntuitions()
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func cancelDeleteButton(_ sender: Any) {
        Utils.showByAdd(uiStackView: socialBarStackView, uiView: deleteButton)
        Utils.animatedHide(uiStackView: footerStackView, uiView: confirmDeleteButton)
        Utils.animatedHide(uiStackView: footerStackView, uiView: cancelDeleteButton)
        
        updateTable()
    }
    
    private func resetSetOutcomeControls() {
        Utils.hide(uiStackView: predictedOutcomeOuterStackView, uiView: selectOutcomeLabel)
        Utils.hide(uiStackView: predictedOutcomeOuterStackView, uiView: selectOutcomeButton)
        Utils.hide(uiStackView: predictedOutcomeOuterStackView, uiView: potentialOutcomesPickerView)
        Utils.hide(uiStackView: predictedOutcomeOuterStackView, uiView: confirmOutcomeButton)
        Utils.hide(uiStackView: predictedOutcomeOuterStackView, uiView: cancelOutcomeButton)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return intuitionDto.potentialOutcomeDtos!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
        }
        
        let title = intuitionDto.potentialOutcomeDtos![row].outcome!.predictionText!
        let nsTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.thin)])
        label?.attributedText = nsTitle
        label?.textAlignment = .center
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 22.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOutcome = intuition.potentialOutcomes![row]
        selectOutcomeButton.setTitle(selectedOutcome!.predictionText, for: .normal)
        selectOutcomeButton.setTitleColor(.darkGray, for: UIControl.State.normal)
        Utils.animatedHide(uiStackView: predictedOutcomeOuterStackView, uiView: pickerView)
        
        Utils.animatedShowByAdd(uiStackView: predictedOutcomeOuterStackView, uiView: confirmOutcomeButton)
        Utils.animatedShowByAdd(uiStackView: predictedOutcomeOuterStackView, uiView: cancelOutcomeButton)
        updateTable()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text!
        if !text.isEmpty {
            SwiftSpinner.show("Adding outcome")
            let intuitionService = appManager.intuitionService
            intuitionService.addOutcome(textField.text!, intuitionId: intuition.id!, completionHandler:  { (response: Response<IntuitionDto>) in
                let intuitionDto = response.data!
                self.resetCell()
                self.addAnOutcomeTextField.text = ""
                self.loadIntuitionDto(intuitionDto)
                self.updateTable()
                SwiftSpinner.hide()
            })
        }
        
        self.addAnOutcomeTextField.endEditing(true)
        self.intuitionTableView?.scrollToView(view: self.userFullName, animated: true)
        
        return false
    }
    
    func updateSocialBar() {
        if intuitionDto.selfLikeDto != nil {
            Utils.setImageAsync(imageView: likeButton.imageView!, newImage: #imageLiteral(resourceName: "777-thumbs-up-toolbar-selected"))
        } else {
            likeButton.imageView?.image = #imageLiteral(resourceName: "777-thumbs-up-toolbar")
        }
        socialBarStackView.setNeedsDisplay()
        socialBarStackView.setNeedsLayout()
        
        var likeCount = intuitionDto.likeDtos!.count
        if intuitionDto.selfLikeDto != nil {
            likeCount += 1
        }
        let hasLikes = likeCount >= 1
        if hasLikes {
            likeCountButton.setTitle("\(likeCount)", for: .normal)
            Utils.show(uiStackView: socialBarStackView, uiView: likeCountButton, insertIndex: 1)
        } else {
            Utils.hide(uiStackView: socialBarStackView, uiView: likeCountButton)
        }
        
        let commentCount = intuitionDto.commentDtos!.count
        if commentCount >= 1 {
            commentCountLabel.text = "\(commentCount)"
            let insertIndex = !hasLikes ? 2 : 3
            Utils.show(uiStackView: socialBarStackView, uiView: commentCountLabel, insertIndex: insertIndex)
        } else {
            Utils.hide(uiStackView: socialBarStackView, uiView: commentCountLabel)
        }
    }
}

