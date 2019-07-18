//
//  WalkthroughFinalViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 11/17/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class WalkthroughFinalViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        exitButton.layer.cornerRadius = 5
    }

    @IBAction func exitButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showTabbar", sender: nil)
    }
    
}
