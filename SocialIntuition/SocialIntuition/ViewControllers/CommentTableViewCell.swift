//
//  CommentTableViewCell.swift
//  SocialIntuition
//
//  Created by Will Stevens on 6/9/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var prettyTimestampLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var intuitionService: IntuitionService = AppManager.appManager.intuitionService
    private var commentDto: CommentDto?
    private var intuitionDto: IntuitionDto?
    private var commentViewController: CommentViewController?
    
    func loadComment(commentDto: CommentDto, intuitionDto: IntuitionDto, commentViewController: CommentViewController) {
        self.commentDto = commentDto
        self.intuitionDto = intuitionDto
        self.commentViewController = commentViewController
        
        setOutlets()
    }
    
    func setOutlets() {
        let comment = commentDto?.comment
        let user = comment?.user
        fullNameLabel.text = user?.fullName
        commentLabel.text = comment?.commentText
        Utils.loadImage(sourceImageInfo: user?.imageInfo, targetImageView: profileImageView)
        prettyTimestampLabel.text = commentDto?.postPrettyTimestamp
        deleteButton.isHidden = !(commentDto!.owner!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fullNameLabel.text = ""
        commentLabel.text = ""
        prettyTimestampLabel.text = ""
        profileImageView.image = #imageLiteral(resourceName: "870-smile")
        deleteButton.isHidden = false
    }
    
    @IBAction func delete_TouchUpInside(_ sender: Any) {
        
        let comment = commentDto!.comment!
        let intuitionId = intuitionDto?.intuition?.id
        intuitionService.removeComment(comment, intuitionId: intuitionId!, completionHandler:  { (response: Response<IntuitionDto>) in
            let intuitionDto = response.data!
            self.commentViewController?.reloadAfterDelete(intuitionDto: intuitionDto)
        })
    }
    
}
