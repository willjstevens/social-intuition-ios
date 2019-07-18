//
//  SearchViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/8/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var appManager = AppManager.appManager
    var searchBar = UISearchBar()
    var searchDto: SearchDto?
    var cohortUserDtos: [UserDto] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        searchForNameString(nameString: "")
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar == self.searchBar) { // all should here but to be safe
            searchForNameString(nameString: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar == self.searchBar) { // all shoulsd but here to be safe
            let searchString = searchBar.text!
            print("Searching with text \(String(describing: searchString))")
            searchForNameString(nameString: searchString)
        }
    }
    
    private func searchForNameString(nameString: String) {
        let accountService = appManager.accountService
//        print("Search for name \(String(describing: nameString))")
        accountService.searchName(name: nameString, completionHandler:  { (response: Response<SearchDto>) in
            self.searchDto = response.data!
            self.cohortUserDtos = (self.searchDto?.userResults)!
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cohortUserDtos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CohortSearchTableViewCell", for: indexPath) as! CohortSearchTableViewCell
        let userDto = cohortUserDtos[indexPath.row]
        cell.loadCell(userDto: userDto, isRequestingUserLoggedIn: (self.searchDto?.requestingUserLoggedIn)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDto = cohortUserDtos[indexPath.row]
        let profileUsername = userDto.user!.username!
        
        // navigate to userprofile
        appManager.accountService.transferUsername = profileUsername
        appManager.applicationService.navigateTo(tabBarTab: .ProfileTab)
    }
}
