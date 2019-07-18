//
//  PredictionView.swift
//  SocialIntuition
//
//  Created by Will Stevens on 8/25/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

class PredictionView: UIView {
    
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var mainContentStackView: UIStackView!
    @IBOutlet weak var predictionTextLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var votedByYouLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var votesButton: UIButton!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    var appManager = AppManager.appManager
    var intuitionCell: IntuitionCell2?
    var baseFeedViewController: BaseFeedViewController?
    var outcomeDto: OutcomeDto?
    var intuitionDto: IntuitionDto?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    func loadNib() {
        if let nibsView = Bundle.main.loadNibNamed("PredictionView", owner: self, options: nil) as? [UIView] {
            let nibRoot = nibsView[0]
            self.addSubview(nibRoot)
            nibRoot.frame = self.bounds
            contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        }
    }

    
    func loadOutcomeDto(intuitionDto: IntuitionDto, idx: Int, intuitionCell: IntuitionCell2, baseFeedViewController: BaseFeedViewController) {
        
        self.intuitionDto = intuitionDto
        self.outcomeDto = intuitionDto.potentialOutcomeDtos![idx-1]
        self.intuitionCell = intuitionCell
        self.baseFeedViewController = baseFeedViewController
        
        predictionTextLabel.text = self.outcomeDto?.outcome?.predictionText
        
        setVotedByYouVisibility()
        setVotedCountVisibility()
        setVoteButtonVisibility()
        
        // don't show the separator if last element in list
        if (idx == intuitionDto.potentialOutcomeDtos!.count) {
            Utils.hide(uiStackView: outerStackView, uiView: separatorView)
        }
    }
    
    
    private func setVotedByYouVisibility() {
        let isVisible =
            intuitionDto!.cohortVotedOutcomeDto != nil &&
                intuitionDto!.cohortVotedOutcomeDto?.outcome?.id == outcomeDto!.outcome?.id

        if !isVisible {
            Utils.hide(uiStackView: mainContentStackView, uiView: starImageView)
            Utils.hide(uiStackView: mainContentStackView, uiView: votedByYouLabel)
        }
    }
    
    private func setVotedCountVisibility() {
        var voteCount = 0
        if let count = outcomeDto!.outcome?.outcomeVoters?.count {
            voteCount = count
        }
        
        // only display for this potential outcome if the person voted and it already has votes
        let isVisible = voteCount >= 1
        //        print("**** setVotedCountVisibility = \(isVisible)")
        
        if !isVisible {
            Utils.hide(uiStackView: mainContentStackView, uiView: tagImageView)
            Utils.hide(uiStackView: mainContentStackView, uiView: votesButton)
        }
        
        // go ahead and always update the text, whether visible or invisible
        switch voteCount {
        case 0: votesButton.setTitle("No Votes", for: .normal)
        case 1: votesButton.setTitle("1 Vote", for: .normal)
        default: votesButton.setTitle("\(voteCount) Votes", for: .normal)
        }
    }
    
    private func setVoteButtonVisibility() {
        let isVisible = intuitionDto!.canVote! && intuitionDto!.canMakeSocialContributions!

        if !isVisible {
            Utils.hide(uiStackView: mainContentStackView, uiView: voteButton)
        }
    }
    
    @IBAction func voteButton_touchupInside(_ sender: Any) {
        SwiftSpinner.show("Voting...")
        let intuitionService = appManager.intuitionService
        let outcome = outcomeDto?.outcome!
        let intuitionId = intuitionDto?.intuition!.id!
        intuitionService.voteForOutcome(outcome!, intuitionId: intuitionId!, completionHandler:  { (response: Response<IntuitionDto>) in
            let intuitionDto = response.data!
            self.intuitionCell?.resetCell()
            self.intuitionCell?.loadIntuitionDto(intuitionDto)
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func whoVotedButton(_ sender: Any) { 
        let intuitionService = appManager.intuitionService
        intuitionService.transferIntuitionDto = self.intuitionDto
        intuitionService.transferIntuitionCell = intuitionCell
        intuitionService.transferParentDto = outcomeDto
        intuitionService.transferLevel = "outcomeVotes"
        intuitionService.transferType = "outcomeVotes"
        
        baseFeedViewController?.performSegue(withIdentifier: "cohortListSegue", sender: nil)
    }

}
