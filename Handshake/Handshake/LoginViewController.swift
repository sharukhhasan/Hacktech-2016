//
//  LoginViewController.swift
//  Handshake
//
//  Created by Justin Jia on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit
import ChameleonFramework
import QuartzCore
import CoreGraphics
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    override func viewDidLoad() {
        view.backgroundColor = GradientColor(.TopToBottom, frame: view.frame, colors: [UIColor.flatSkyBlueColor(), UIColor.flatBlueColorDark()])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            
            performSegueWithIdentifier("loginSegue", sender: nil)
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email"]
            loginView.delegate = self
            
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("public_profile")
            {
                // Do work
                print("Logged in!")
                //Send the data to other controller?
                performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
}
