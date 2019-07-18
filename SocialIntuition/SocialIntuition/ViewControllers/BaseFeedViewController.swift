//
//  ActivityFeedViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 7/27/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class BaseFeedViewController: UIViewController {


    var appManager = AppManager.appManager
    var intuitionDtos = [IntuitionDto]()
    var tableViewRef: UITableView?
    
    func updateIntuitionDto(intuitionDto: IntuitionDto, indexPath: IndexPath) {
        let row = indexPath.row
        self.intuitionDtos[row] = intuitionDto
    }
    
    func loadIntuitions() {
        preconditionFailure("loadIntuitions() must be overridden.")
    }
    
    func postConfirmOutcome() {

    }

    
}




