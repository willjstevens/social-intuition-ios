//
//  SITabBarController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 9/28/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class SITabBarController: UITabBarController {

    let appManager = AppManager.appManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.appManager.tabBarController = self
    }


}
