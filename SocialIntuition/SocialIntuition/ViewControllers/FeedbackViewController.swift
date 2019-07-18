//
//  FeedbackViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 12/12/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

class FeedbackViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var appManager = AppManager.appManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.cornerRadius = 3
        disableSubmit()
        
        textView.delegate = self
        textView.layer.borderWidth = 0.6
        textView.layer.cornerRadius = 2
        textView.layer.borderColor = Constants.siPrimaryBorderColor.cgColor
        textView.returnKeyType = UIReturnKeyType.done
        
    }

    private func validate() {
        let isTextViewValid = !textView.text.isEmpty
        
        if isTextViewValid {
            enableSubmit()
        } else {
            disableSubmit()
        }
    }

    private func enableSubmit() {
        submitButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        submitButton.isEnabled = true
    }
    
    private func disableSubmit() {
        submitButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
        submitButton.isEnabled = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validate()
    }

    
    @IBAction func submitButton_touchUpInside(_ sender: Any) {
        
        let user = appManager.accountService.session.user
        let feedback = Feedback()
        feedback.name = user?.fullName
        feedback.email = user?.email
        feedback.comment = textView.text
        
        
        SwiftSpinner.show("Sending comment...")
        
        // call login
        appManager.applicationService.addFeedback(feedback: feedback, completionHandler: { (response: Response<Void>) ->
            () in
            
                SwiftSpinner.hide()
                
            let alertController = UIAlertController(title: "Thank you.", message: "Your message has been received. ", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                action in
                
                self.performSegue(withIdentifier: "unwindFeedbackController", sender: nil)
            }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
        
            
        })
    }
    
}
