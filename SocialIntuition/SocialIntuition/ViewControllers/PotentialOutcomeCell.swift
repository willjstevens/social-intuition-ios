//
//  PotentialOutcomeCell.swift
//  SocialIntuition
//
//  Created by Will Stevens on 5/13/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import Foundation
import UIKit

class PotentialOutcomeCell: UITableViewCell
{
    
    @IBOutlet weak var predictionText: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var votedByYouLabel: UILabel!
    @IBOutlet weak var tagImage: UIImageView!
    @IBOutlet weak var votesLabel: UILabel!
    
    // constraints for fixed size views
    @IBOutlet weak var voteButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var starImageHeight: NSLayoutConstraint!
    @IBOutlet weak var starImageWidth: NSLayoutConstraint!
    @IBOutlet weak var starAspectRatio: NSLayoutConstraint!
    @IBOutlet weak var tagImageHeight: NSLayoutConstraint!
    @IBOutlet weak var tagImageWidth: NSLayoutConstraint!
    @IBOutlet weak var tagAspectRatio: NSLayoutConstraint!
    
    var outcomeDto: OutcomeDto?
    var intuitionDto: IntuitionDto?
    
    
    func loadOutcomeDto(_ outcomeDto: OutcomeDto, intuitionDto: IntuitionDto) {
        
        self.outcomeDto = outcomeDto
        self.intuitionDto = intuitionDto
        
        predictionText.text = outcomeDto.outcome?.predictionText
        
        voteButton.layer.cornerRadius = 4
        voteButton.imageView?.contentMode = .scaleAspectFit
        
//        print("**** voteButtonWidth?.constant = \(String(describing: voteButtonWidth?.constant)) and priority = \(String(describing: voteButtonWidth?.priority))")
        
        setVotedByYouVisibility()
        setVotedCountVisibility()
        setVoteButtonVisibility()
    }
    
    
    private func setVotedByYouVisibility() {
        let isVisible =
            intuitionDto!.cohortVotedOutcomeDto != nil &&
                intuitionDto!.cohortVotedOutcomeDto?.outcome?.id == outcomeDto!.outcome?.id
//        print("**** setVotedByYouVisibility = \(isVisible)")
        
        starImageWidth?.constant = isVisible ? 16 : 0
        starImageHeight?.constant = isVisible ? 16 : 0
        // NO IDEA why this condition needs to be OPPOSITE of isVisible, but found a clue here https://stackoverflow.com/questions/40043405/programmatically-removing-adding-constraints-animated
        starAspectRatio?.isActive = !isVisible

//        print("**** starImageWidth?.constant = \(String(describing: starImageWidth?.constant)) and priority = \(String(describing: starImageWidth?.priority))")
//        print("**** starImageHeight?.constant = \(String(describing: starImageHeight?.constant)) and priority = \(String(describing: starImageHeight?.priority))")
//        print("**** starAspectRatio?.multiplier = \(String(describing: starAspectRatio?.multiplier)) and priority = \(String(describing: starAspectRatio?.priority))")
        
        Utils.setVisibility(view: starImage, isVisible: isVisible)
        Utils.setVisibility(view: votedByYouLabel, isVisible: isVisible)
        
        starImage.layoutIfNeeded()
    }
    
    private func setVotedCountVisibility() {
        var voteCount = 0
        if let count = outcomeDto!.outcome?.outcomeVoters?.count {
            voteCount = count
        }
        
        // only display for this potential outcome if the person voted and it already has votes
        let isVisible = voteCount >= 1
//        print("**** setVotedCountVisibility = \(isVisible)")
        
        tagImageWidth?.constant = isVisible ? 16 : 0
        tagImageHeight?.constant = isVisible ? 16 : 0
        // NO IDEA why this condition needs to be OPPOSITE of isVisible, but found a clue here https://stackoverflow.com/questions/40043405/programmatically-removing-adding-constraints-animated
        tagAspectRatio?.isActive = !isVisible
        Utils.setVisibility(view: tagImage, isVisible: isVisible)
        Utils.setVisibility(view: votesLabel, isVisible: isVisible)
        tagImage.layoutIfNeeded()
        
        // go ahead and always update the text, whether visible or invisible
        switch voteCount {
        case 0: votesLabel.text = "No Votes"
        case 1: votesLabel.text = "1 Vote"
        default: votesLabel.text = "\(voteCount) Votes"
        }
    }
    
    private func setVoteButtonVisibility() {
        let isVisible = intuitionDto!.canVote! && intuitionDto!.canMakeSocialContributions!
//        print("**** setVoteButtonVisibility = \(isVisible)")
        voteButtonWidth?.constant = isVisible ? 70 : 0
        
        Utils.setVisibility(view: voteButton, isVisible: isVisible)
        Utils.setVisibility(view: voteButton.imageView!, isVisible: isVisible)
        voteButton.layoutIfNeeded()
    }
    
    
    
}
