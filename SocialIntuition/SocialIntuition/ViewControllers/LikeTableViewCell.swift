//
//  LikeTableViewCell.swift
//  SocialIntuition
//
//  Created by Will Stevens on 6/23/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameButton: UIButton!

    private var appManager = AppManager.appManager
    private var intuitionService: IntuitionService = AppManager.appManager.intuitionService
    private var likeDto: LikeDto?
    private var intuitionDto: IntuitionDto?
    private var likeViewController: LikeViewController?
    private var isSelfLike: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 3
    }
    
    func loadLike(likeDto: LikeDto, intuitionDto: IntuitionDto, isSelfLike: Bool, likeViewController: LikeViewController) {
        self.likeDto = likeDto
        self.intuitionDto = intuitionDto
        self.likeViewController = likeViewController
        self.isSelfLike = isSelfLike
        
        setOutlets()
    }
    
    func setOutlets() {
        let user = likeDto?.like?.user
        fullNameButton.setTitle(user?.fullName, for: .normal)
        Utils.loadImage(sourceImageInfo: user?.imageInfo, targetImageView: profileImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fullNameButton.setTitle("", for: .normal)
        profileImageView.image = #imageLiteral(resourceName: "870-smile")
        isSelfLike = false
    }

    @IBAction func nameSelected(_ sender: Any) {
        
        // first navigate to profile
        let accountService = appManager.accountService
        accountService.transferUsername = likeDto?.like?.user?.username!
        let applicationService = appManager.applicationService
        applicationService.navigateTo(tabBarTab: .ProfileTab)
        
        // then pop back to root view controller
        //      (don't ask me why this comes second and not first; see https://stackoverflow.com/questions/21681185/tabbar-disappears-when-selectedindex-value-changes-on-ios-7)
        likeViewController?.navigationController?.popViewController(animated: false)
    }
}
