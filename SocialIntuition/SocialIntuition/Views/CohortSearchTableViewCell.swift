//
//  CohortSearchTableViewCell.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/17/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class CohortSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    var userDto: UserDto?
    var isRequestingUserLoggedIn: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetCell()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }

    private func resetCell() {
        profileImageView.image = #imageLiteral(resourceName: "placeholderImg")
        userFullNameLabel.text = ""
    }
    
    func loadCell(userDto: UserDto, isRequestingUserLoggedIn: Bool) {
        self.userDto = userDto
        self.isRequestingUserLoggedIn = isRequestingUserLoggedIn
        
        let user = userDto.user!
        if let imageInfo = user.imageInfo {
            Utils.loadImage(sourceImageInfo: imageInfo, targetImageView: profileImageView)
        }
        userFullNameLabel.text = user.fullName
    }
}
