//
//  AppManager.swift
//  Social Intuition
//
//  Created by Will Stevens on 12/31/16.
//  Copyright © 2016 Will Stevens. All rights reserved.
//

import Foundation
import UIKit

class AppManager {
    
    static let appManager = AppManager()
    var session: Session
    var accountService: AccountService
    var applicationService: ApplicationService
    var intuitionService: IntuitionService
    
    // framework references
    var tabBarController: UITabBarController?
    
    init() {
        session = Session()
        let httpClient = HttpClient()
        let settings = Settings.settings
        
        // general
        httpClient.initialize()
        
        // some circular references but hey it is convenient
        session.httpCient = httpClient
        session.settings = settings
        httpClient.session = session;
         
        // setup account service
        accountService = AccountService(session, httpClient);
        applicationService = ApplicationService(session, httpClient)
        intuitionService = IntuitionService(session, httpClient);
    }
    
    func postInit() {
        applicationService.appManager = self
    }
}
