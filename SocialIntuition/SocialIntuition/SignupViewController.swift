//
//  SignupController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/8/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

class SignupViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var profilePhotoWarning: UILabel!
    @IBOutlet weak var emailWarning: UILabel!
    @IBOutlet weak var usernameWarning: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    var appManager = AppManager.appManager
    var selectedImage: UIImage?
    var usernameIsValid = false
    var emailIsValid = false
    var profilePhotoIsValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if here in registration, then go ahead and cleanup device ID info
        appManager.session.cleanup()
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        emailTextField.borderStyle = UITextField.BorderStyle.none
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: emailTextField.frame.width, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor.white.cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.tintColor = UIColor.white
        usernameTextField.textColor = UIColor.white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        usernameTextField.borderStyle = UITextField.BorderStyle.none
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: usernameTextField.frame.width, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor.white.cgColor
        usernameTextField.layer.addSublayer(bottomLayerUsername)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: passwordTextField.frame.width, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor.white.cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        firstNameTextField.backgroundColor = UIColor.clear
        firstNameTextField.tintColor = UIColor.white
        firstNameTextField.textColor = UIColor.white
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        firstNameTextField.borderStyle = UITextField.BorderStyle.none
        let bottomLayerFirstName = CALayer()
        bottomLayerFirstName.frame = CGRect(x: 0, y: 29, width: firstNameTextField.frame.width, height: 0.6)
        bottomLayerFirstName.backgroundColor = UIColor.white.cgColor
        firstNameTextField.layer.addSublayer(bottomLayerFirstName)
        
        lastNameTextField.backgroundColor = UIColor.clear
        lastNameTextField.tintColor = UIColor.white
        lastNameTextField.textColor = UIColor.white
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastNameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        lastNameTextField.borderStyle = UITextField.BorderStyle.none
        let bottomLayerLastName = CALayer()
        bottomLayerLastName.frame = CGRect(x: 0, y: 29, width: lastNameTextField.frame.width, height: 0.6)
        bottomLayerLastName.backgroundColor = UIColor.white.cgColor
        lastNameTextField.layer.addSublayer(bottomLayerLastName)
        
        profileImage.layer.cornerRadius = 15
        profileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        // remove initially
        usernameWarning.isHidden = true
        emailWarning.isHidden = true
        profilePhotoWarning.isHidden = true
        
        // added to dismiss keyboard
        lastNameTextField.delegate = self
        lastNameTextField.returnKeyType = .done
        
        
        handleTextField()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lastNameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        firstNameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        lastNameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        
        // by default, set to false
        signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
        signUpButton.isEnabled = false
        
        let email = emailTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        
        if (!email.isEmpty && !username.isEmpty && !password.isEmpty && !firstName.isEmpty && !lastName.isEmpty) {
            let applicationService = appManager.applicationService
            
            // validate username use
            let usernameCharCount = (usernameTextField.text?.count)!
            if usernameCharCount >= 2 {
                applicationService.checkUsernameAvailability(username: self.usernameTextField.text!, completionHandler: { (response: Response<Void>) in
                    // set response
                    if response.success {
                        self.usernameWarning.isHidden = true
                        self.usernameIsValid = true
                    } else {
                        self.usernameWarning.isHidden = false
                        self.usernameIsValid = false
                    }
                    self.validate()
                })
            }
            
            // validate email use
            let emailCharCount = (emailTextField.text?.count)!
            if emailCharCount >= 3 {
                applicationService.checkEmailAvailability(email: self.emailTextField.text!, completionHandler: { (response: Response<Void>) in
                    // set response
                    if response.success {
                        self.emailWarning.isHidden = true
                        self.emailIsValid = true
                    } else {
                        self.emailWarning.isHidden = false
                        self.emailIsValid = false
                    }
                    self.validate()
                })
            }
        }
    
        validate()
    }
    
    func validate() {
        
        // false by default
        signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
        signUpButton.isEnabled = false
        
        if self.selectedImage == nil {
            profilePhotoWarning.isHidden = false
            profilePhotoIsValid = false
        } else {
            profilePhotoWarning.isHidden = true
            profilePhotoIsValid = true
        }
        
        
        let email = emailTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        
        if (!email.isEmpty &&
            !username.isEmpty &&
            !password.isEmpty &&
            !firstName.isEmpty &&
            !lastName.isEmpty &&
            usernameIsValid &&
            emailIsValid &&
            profilePhotoIsValid)
        {
            self.signUpButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.signUpButton.isEnabled = true
        }
    }

    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn_touchUpInside(_ sender: Any) {
        let accountService = appManager.accountService
        let email = emailTextField.text
        let username = usernameTextField.text
        let password = passwordTextField.text
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        view.endEditing(true)
        SwiftSpinner.show("Signing up...")
        
        // call registration
        accountService.signup(email!, username!, password!, firstName!, lastName!, signupCompletionHandler: { (signupResponse: Response<User>) ->
            () in
            let user = signupResponse.data
            
            self.validate()
            
            let username = user?.username
            let password = user?.password
            // now call login
            accountService.loginByUsernamePassword(username!, password!, loginCompletionHandler: { (loginResponse: Response<DeviceLoginDto>) ->
                () in
                
                // upload photo if present
                if let profileImage = self.selectedImage {
                    accountService.upload(image: profileImage, uploadCompletionHandler: { (signupResponse: Response<User>) ->
                        () in
//                        print("****** UPLOADED ******")
                    })
                }
                
//                self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
                // For now, always show walkthrough first
                self.performSegue(withIdentifier: "showWalkthrough", sender: nil)
            })
        })

    }
    
    private func displayAlert(_ message: String) {
        let alertController = UIAlertController(title: message, message: "Sorry.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage.image = image
            selectedImage = image
            validate()
        }
        dismiss(animated: true, completion: nil)
    }
}
