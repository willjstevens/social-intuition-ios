//
//  ActivityFeedViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 7/27/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

class ActivityFeedViewController: BaseFeedViewController, UIScrollViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var activityFeedStart: Int = 0
    var activityFeedQuantity: Int = 25
    var refreshControl = UIRefreshControl()
    var canRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self // for scrollview event
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableViewRef = tableView
        
        loadIntuitions()
        
        // setup refresh controller
        // The below attributedTitle commenttee out due to it breaking the action call to the UIRefreshControl
//        refreshControl.attributedTitle = NSAttributedString(string: "Fetching intuitions...")
//        refreshControl.addTarget(self, action: #selector(self.fetchIntuitionsSinceLastUpdate), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        }
        // need this for just UITableView and non-UIableViewController
        tableView.addSubview(refreshControl)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("contentOffset.y = \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y < -100 {
//            print("canRefresh = \(canRefresh) !isRefreshing = \(!self.refreshControl.isRefreshing) ")
            if canRefresh && !self.refreshControl.isRefreshing {
                self.canRefresh = false
                self.refreshControl.beginRefreshing()
                self.fetchIntuitionsSinceLastUpdate()
            }
        } else if scrollView.contentOffset.y >= 0 {
            self.canRefresh = true
//            print("canRefresh = TRUE")
        }
    }

    
    @objc private func fetchIntuitionsSinceLastUpdate() {
        print("***** Fetching latest intuitions")
        let intuitionService = appManager.intuitionService
        intuitionService.fetchIntuitionsSinceLastUpdate() { (response: ResponseWithArray<IntuitionDto>) in
            let intuitionDtos = response.data!
            if !intuitionDtos.isEmpty {
                for i in (1...intuitionDtos.count).reversed() {
                    let idx = i - 1
                    let intuitionDto = intuitionDtos[idx]
                    self.intuitionDtos.insert(intuitionDto, at: 0)
                }
                self.tableView.reloadData()
            }
            self.canRefresh = true
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        let intuitionService = appManager.intuitionService
        if case .AddIntuition? = intuitionService.transferFrom {
            self.loadIntuitions()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        reset()
    }
    
    private func reset() {
    }
    
    override func loadIntuitions() {
        let intuitionService = appManager.intuitionService
        intuitionService.fetchIntuitionsForActivityFeed(start: activityFeedStart, quantity: activityFeedQuantity) { (response: ResponseWithArray<IntuitionDto>) in
            let intuitionDtos = response.data!
            self.handleIntuitions(newIntuitions: intuitionDtos)
            intuitionService.resetTransfers()
            SwiftSpinner.hide()
        }
    }
    
    override func postConfirmOutcome() {
    }
    
    func handleIntuitions(newIntuitions: [IntuitionDto]) {
        self.intuitionDtos.removeAll()
        if !newIntuitions.isEmpty {
            self.intuitionDtos += newIntuitions
        } else {
            displayNoIntuitions()
            return
        }
        
        self.tableView.reloadData()
        
        // now reload data and close it out
        let intuitionService = appManager.intuitionService
        if case .ScrollToForIntuition? = intuitionService.transferAction {
            self.handleScrollTo(newIntuitions: newIntuitions)
        } else if case .ScrollToForOutcome? = intuitionService.transferAction {
            self.handleScrollTo(newIntuitions: newIntuitions)
        }
        
    }
    
    private func handleScrollTo(newIntuitions: [IntuitionDto]) {
        let intuitionService = appManager.intuitionService
        let intuition = intuitionService.transferIntuition!
        // iterate through current intuitionDtos to find index
        var idx = 0
        for intuitionDto in newIntuitions {
            if intuition.id! == intuitionDto.intuition?.id! {
                break
            }
            idx += 1
        }
        
        // now do scroll to
        let indexPath = IndexPath(row: idx, section: 0)
//        print("Scrolling to index: \(idx)")
        if case .ScrollToForIntuition? = intuitionService.transferAction {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else if case .ScrollToForOutcome? = intuitionService.transferAction {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    
    private func displayNoIntuitions() {
        let alertController = UIAlertController(title: "Alert", message: "No Intuitions. Add some!", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: UIAlertAction.Style.default,
                                     handler: {(alert: UIAlertAction!)
                                        in
                                        self.appManager.applicationService.navigateTo(tabBarTab: .AddIntuitionTab)
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ActivityFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intuitionDtos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntuitionCell2", for: indexPath) as! IntuitionCell2
        let intuitionDto = intuitionDtos[indexPath.row]
        cell.loadIntuitionDto(intuitionDto, intuitionTableView: tableView, baseFeedViewController: self, indexPath: indexPath)
        return cell
    }
}

