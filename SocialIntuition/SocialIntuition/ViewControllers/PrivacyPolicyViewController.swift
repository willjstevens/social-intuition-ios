//
//  PrivacyPolicyViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 11/9/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import WebKit
import SwiftSpinner

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate

{

    @IBOutlet weak var privacyPolicyWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        privacyPolicyWebView.navigationDelegate = self
        SwiftSpinner.show("Loading...")
        privacyPolicyWebView.load(URLRequest(url: URL(string: "https://www.socialintuition.co/html/legal/privacy-policy.html")!))
        
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftSpinner.hide()
    }

    
}
