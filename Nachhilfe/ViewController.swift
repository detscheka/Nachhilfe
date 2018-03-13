//
//  ViewController.swift
//  Nachhilfe
//
//  Created by Tschekalinskij, Alexander on 07.03.18.
//  Copyright © 2018 Tschekalinskij, Alexander. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var eMailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var ResetPasswordBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        
        LogInButton.layer.borderWidth = 1
        LogInButton.layer.borderColor = LogInButton.tintColor.cgColor
        LogInButton.layer.cornerRadius = 15
        
        RegisterButton.layer.borderWidth = 1
        RegisterButton.layer.borderColor = RegisterButton.tintColor.cgColor
        RegisterButton.layer.cornerRadius = 15
        
        ResetPasswordBtn.layer.borderWidth = 1
        ResetPasswordBtn.layer.borderColor = ResetPasswordBtn.tintColor.cgColor
        ResetPasswordBtn.layer.cornerRadius = 15
        
        LogInButton.tag = 1
        RegisterButton.tag = 2
        ResetPasswordBtn.tag = 3
        
    }
    
    fileprivate func setupButtons() {
        let logInFacebookButton = FBSDKLoginButton()
        view.addSubview(logInFacebookButton)
        logInFacebookButton.frame = CGRect(x: 16, y: self.passwordField.frame.midY + 50, width: view.frame.width - 30, height: 50)
        logInFacebookButton.delegate = self
        logInFacebookButton.readPermissions = ["email", "public_profile"]
        
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: logInFacebookButton.frame.midY + 50, width: view.frame.width - 30, height: 50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func LogInPressed(_ sender: UIButton) {
        
        switch sender.tag
        {
        case 1:
            if self.eMailField.text == "" || self.passwordField.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                Auth.auth().signIn(withEmail: self.eMailField.text!, password: self.passwordField.text!) {
                    (user, error) in
                    if error == nil {
                        print("You have successfully logged in")
                        
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        case 2:
            print("case2\n")
        case 3:
            print("case3\n")
        default:
            break
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error.localizedDescription)
            return
        }
        
        guard let token = FBSDKAccessToken.current().tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credentials) { (user, err) in
            if err != nil {
                print("Error occured while logging into Firebase with Facebook: ", err!)
                return
            }
            
            print("Successfully logged into Firebase with Facebook ", user!)
        }
        
        print("logged in!\n")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print("Failed to start graph re request: ", err!)
                return
            }
            
            print(result!)
        }
    }   
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out!\n")
    }
    
}

