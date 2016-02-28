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
import CoreData
import PGMappingKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var facebookid: NSString = ""
    var username: NSString = ""
    var userEmail:NSString = ""
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        view.backgroundColor = GradientColor(.TopToBottom, frame: view.frame, colors: [UIColor.flatSkyBlueColor(), UIColor.flatBlueColorDark()])
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = delegate.managedObjectContext

        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            if (NSUserDefaults.standardUserDefaults().objectForKey("UserEmail") != nil)
            {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("UserEmail") == nil) {
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
                self.getFBUserData()
                performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    var dictionary = result as! [String : AnyObject]
                    print(dictionary)
                    let picture = dictionary["picture"] as! [String : AnyObject]
                    let data = picture["data"] as! [String : AnyObject]
                    dictionary["image_url"] = data["url"]
                    let mapping = PGMappingDescription(localName: "Person", remoteName: "Person", localIDKey: "email", remoteIDKey: "email", mapping: ["last_name": "lastName", "first_name": "firstName", "image_url": "imageUrl"])
                    let user = self.context.save(dictionary, description: mapping, error: nil) as! Person
                    NSUserDefaults.standardUserDefaults().setObject(user.email, forKey: "UserEmail")
                    try! self.context.save()
                }
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
}
