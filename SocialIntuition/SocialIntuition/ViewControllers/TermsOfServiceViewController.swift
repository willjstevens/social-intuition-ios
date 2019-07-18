//
//  TermsOfServiceViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 11/9/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import WebKit
import SwiftSpinner

class TermsOfServiceViewController: UIViewController {

    @IBOutlet weak var termsOfServiceWebView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftSpinner.show("Loading...")
        termsOfServiceWebView.load(URLRequest(url: URL(string: "https://www.socialintuition.co/html/legal/terms-of-service.html")!))
        SwiftSpinner.hide()
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
