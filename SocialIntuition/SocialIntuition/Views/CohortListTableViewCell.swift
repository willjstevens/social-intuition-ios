//
//  CohortListTableViewCell.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/9/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class CohortListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    private var intuitionService: IntuitionService = AppManager.appManager.intuitionService
    private var user: User?
    private var intuitionDto: IntuitionDto?
    private var cohortListViewController: CohortListViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 3
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        // TODO: segue here to profile page
        
    }
    
    
    func loadCohort(user: User, intuitionDto: IntuitionDto, cohortListViewController: CohortListViewController) {
        self.user = user
        self.intuitionDto = intuitionDto
        self.cohortListViewController = cohortListViewController
        
        setOutlets()
    }
    
    func setOutlets() {
        fullNameLabel.text = user?.fullName
        Utils.loadImage(sourceImageInfo: user?.imageInfo, targetImageView: profileImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fullNameLabel.text = ""
        profileImageView.image = #imageLiteral(resourceName: "870-smile")
    }
    
    
}
