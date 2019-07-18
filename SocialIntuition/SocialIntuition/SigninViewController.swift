//
//  SigninViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/8/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

class SigninViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var appManager = AppManager.appManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        logoImageView.layer.cornerRadius = 5
        logoImageView.clipsToBounds = true
        
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.tintColor = UIColor.white
        usernameTextField.textColor = UIColor.white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        usernameTextField.borderStyle = UITextField.BorderStyle.none
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: usernameTextField.frame.width, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor.white.cgColor
        usernameTextField.layer.addSublayer(bottomLayerEmail)
        
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: passwordTextField.frame.width, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor.white.cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        // added to dismiss keyboard
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        
        handleTextField()
        textFieldDidChange()
        
        // DELETE ME
//        usernameTextField.text = "tu1"
//        passwordTextField.text = "password"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        passwordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // if already has local dormant session, then login
        if appManager.session.hasDeviceSession() {
//            SwiftSpinner.show("Signing in...")
            
            let accountService = appManager.accountService
            accountService.loginByDeviceSession(loginCompletionHandler: { (loginResponse: Response<DeviceLoginDto>) ->
                () in
                
                if loginResponse.success {
                    self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
//                    self.performSegue(withIdentifier: "showWalkthrough", sender: nil)
                } else {
                    self.displayAlert(loginResponse.message!)
                }
                
            })
        }
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                signInButton.isEnabled = false
                return
        }
        
        signInButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        signInButton.isEnabled = true
    }
    
    
    @IBAction func signIn_touchUpInside(_ sender: Any) {
        let accountService = appManager.accountService
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        
        view.endEditing(true)
        SwiftSpinner.show("Logging in...")
        
        // call login
        accountService.loginByUsernamePassword(username!, password!, loginCompletionHandler: { (loginResponse: Response<DeviceLoginDto>) ->
            () in
            
            if loginResponse.success {
                self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
//                self.performSegue(withIdentifier: "showWalkthrough", sender: nil)
            } else {
                SwiftSpinner.hide()
                self.displayAlert(loginResponse.message!)
            }
            
        })
    }
    
    private func displayAlert(_ message: String) {
        let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
