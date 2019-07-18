//
//  LikeViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 6/23/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var intuitionService: IntuitionService = AppManager.appManager.intuitionService
    private var currentIntuitionDto: IntuitionDto?
    private var currentIntuitionCell: IntuitionCell2?
    private var currentLevel: String?
    private var currentType: String?
    private var likeDtos: [LikeDto]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        // chop off other rows in table
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.isTranslucent = false
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
        currentLevel = intuitionService.transferLevel
        currentType = intuitionService.transferType
        
        // set level
        if currentLevel == "intuition" {
            likeDtos = currentIntuitionDto?.likeDtos
        } else if currentLevel == "outcome" {
            likeDtos = currentIntuitionDto?.outcomeDto?.likeDtos
        }
        
        
    }
    
    func setView() {
        var likeCount = likeDtos!.count
        if currentIntuitionDto?.selfLikeDto != nil {
            likeCount += 1
        }
        if likeCount == 1 {
            self.title = "1 Like"
        } else if likeCount >= 2 {
            self.title = "\(likeCount) Likes"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let intuitionDto = currentIntuitionDto {
            count += intuitionDto.likeDtos!.count
            if intuitionDto.selfLikeDto != nil {
                count += 1
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeCell", for: indexPath) as! LikeTableViewCell
        
        let hasSelfLike = currentIntuitionDto?.selfLikeDto != nil
        var index = indexPath.row
        
        if index == 0 && hasSelfLike {
            cell.loadLike(likeDto: currentIntuitionDto!.selfLikeDto!, intuitionDto: currentIntuitionDto!, isSelfLike: true, likeViewController: self)
        } else {
            if hasSelfLike {
                index -= 1 // subtract 1 since first row index pertained to the selfLikeDto
            }
            let likeDto = likeDtos![index]
            cell.loadLike(likeDto: likeDto, intuitionDto: currentIntuitionDto!, isSelfLike: false, likeViewController: self)
        }
        
        return cell
    }
    



}
