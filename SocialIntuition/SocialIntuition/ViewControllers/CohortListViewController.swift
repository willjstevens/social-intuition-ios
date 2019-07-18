//
//  CohortListViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/9/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class CohortListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var intuitionService: IntuitionService = AppManager.appManager.intuitionService
    private var currentIntuitionDto: IntuitionDto?
    private var currentIntuitionCell: IntuitionCell2?
    private var currentLevel: String?
    private var currentType: String?
    private var currentParentDto: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        // chop off other rows in table
//        self.tableView.tableFooterView = UIView()
//        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        // fetch it now
        setTransfers()
        setView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        // cleanup
        intuitionService.resetTransfers()
    }
    
    func setTransfers() {
        currentIntuitionDto = intuitionService.transferIntuitionDto
        currentIntuitionCell = intuitionService.transferIntuitionCell
        currentParentDto = intuitionService.transferParentDto
        currentLevel = intuitionService.transferLevel
        currentType = intuitionService.transferType
        
    }
    
    func setView() {
        
        // set title
        if currentType == "likes" {
            self.title = "Who liked this"
        } else if (currentType == "commentLikes") {
            self.title = "Who liked this comment"
        } else if (currentType == "outcomeVotes") {
            self.title = "Who voted for this"
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        count = getUserList().count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CohortCell", for: indexPath) as! CohortListTableViewCell
        let user = getUserList()[indexPath.row]
        cell.loadCohort(user: user, intuitionDto: currentIntuitionDto!, cohortListViewController: self)
        
        return cell
    }

    //
    // transposed from si-directives.js -> cohortListDirective
    //
    private func getUserList() -> [User] {
        var users: [User] = []

        var parentBase: Any = Intuition()
        switch (currentLevel!) {
            case "intuition":       parentBase = currentIntuitionDto!.intuition!
            case "outcome":         parentBase = (currentParentDto as! OutcomeDto).outcome!
            case "outcomeVotes":    parentBase = (currentParentDto as! OutcomeDto).outcome!
            default: print("Unrecognized currentLevel (e.g. intuition, outcome, outcomeVotes)")
        }
        
        
        var typeParent: [Any] = []
        switch (currentType!) {
            // TODO: add these type handlers in when needed
//            case "likes":       typeParent = (parentBase as! Intuition).likes
//            case "commentLikes":       typeParent = //$scope.commentDto.comment.likes;
            case "outcomeVotes":       typeParent = (parentBase as! Outcome).outcomeVoters!
            default: print("Unrecognized currentType (e.g. like, commentLikes, outcomeVotes)")
        }
        
        for type in typeParent {
            var user: User = User()
            if currentType == "likes" || currentType == "commentLikes" {
                user = (type as! Like).user!
            } else if (currentType == "outcomeVotes") {
                user = type as! User
            }
            users.append(user)
        }

        // TODO: add guest filtering logic
        
        
        return users
    }
    
}
