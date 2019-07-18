//
//  SettingsViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 11/6/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var howItWorksIconView: UIView!
    @IBOutlet weak var provideFeedbackView: UIView!
    @IBOutlet weak var logoutIconView: UIView!
    
    private var appManager = AppManager.appManager
    private var accountService: AccountService = AppManager.appManager.accountService
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        howItWorksIconView.layer.cornerRadius = 5
        provideFeedbackView.layer.cornerRadius = 5
        logoutIconView.layer.cornerRadius = 5
    }

    @IBAction func closeButtonTouched(_ sender: Any) {
        accountService.transferDoLoadProfile = false
        dismiss(animated: true, completion: {
            self.accountService.resetTransfers()
        })
    }
    
    @IBAction func howItWorks_TouchupInside(_ sender: Any) {
        self.performSegue(withIdentifier: "showWalkthrough", sender: nil)
    }
   
    @IBAction func provideFeedback_TouchupInside(_ sender: Any) {
        self.performSegue(withIdentifier: "showFeedback", sender: nil)
    }
    
    @IBAction func logout_TouchupInside(_ sender: Any) {
        SwiftSpinner.show("Logging out...")
        let accountService = self.accountService
        accountService.logout(logoutCompletionHandler: { (response: Response<Void>) ->
            () in
            
            SwiftSpinner.hide()
            if response.success {
                accountService.transferDoLoadProfile = false
                self.dismiss(animated: false, completion: {
                    accountService.resetTransfers()
                    let storyboard = UIStoryboard(name: "Start", bundle: nil)
                    let signInVC = storyboard.instantiateViewController(withIdentifier: "SigninViewController")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = signInVC
                })
            }
        })
    }

    @IBAction func privacyPolicy_TouchupInside(_ sender: Any) {
        self.performSegue(withIdentifier: "privacyPolicySegue", sender: nil)
    }
    
    @IBAction func termsOfService_TouchupInside(_ sender: Any) {
        self.performSegue(withIdentifier: "termsOfServiceSegue", sender: nil)
    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
}
