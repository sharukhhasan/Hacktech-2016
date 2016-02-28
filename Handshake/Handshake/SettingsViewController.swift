//
//  SettingsViewController.swift
//  Handshake
//
//  Created by Sharukh Hasan on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import Foundation
import CoreData
import ChameleonFramework
import QuartzCore
import CoreGraphics

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var currentUserID: NSString = ""
    var user: Person?
    var context: NSManagedObjectContext?

    var firstName: String?
    var lastName: String?
    var email: String?
    
    let arraySettings = ["First Name", "Last Name", "Email", "Phone Number", "Company", "Facebook Link", "LinkedIn Link"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("UserEmail") as! String
        user = try! context?.objectWithType("Person", identifier: userEmail, forKey: "email") as! Person

        view.backgroundColor = GradientColor(.TopToBottom, frame: view.frame, colors: [UIColor.flatSkyBlueColor(), UIColor.flatBlueColorDark()])
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    @IBAction func textFieldEditingChanged(sender: UITextField) {
        switch sender.tag {
        case 0:
            firstName = sender.text
            break
        case 1:
            lastName = sender.text
            break
        case 2:
            email = sender.text
            break
        default:
            print("Unknown text field.")
            break
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        if let firstName = firstName {
            user?.firstName = firstName
        }

        if let lastName = lastName {
            user?.lastName = lastName
        }

        if let email = email {
            user?.email = email
        }

        try! context?.save()

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        switch sender.tag {
        case 0:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "FirstNameOff")
            break
        case 1:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "LastNameOff")
            break
        case 2:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "emailOff")
            break
        default:
            print("Unknown switch.")
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell")! as! SettingsCell
        cell.backgroundColor = UIColor.clearColor()
        cell.nameLabel?.text = arraySettings[indexPath.row]
        cell.nameLabel.tag = indexPath.row
        cell.uiSwitch.tag = indexPath.row

        switch indexPath.row {
            case 0:
                cell.textField?.text = user?.firstName
                cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("FirstNameOff")
                break
            case 1:
                cell.textField?.text = user?.lastName
                cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("lastNameOff")
                break
            case 2:
                cell.textField?.text = user?.email
                cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("lastNameOff")
                break
            case 3:
                cell.textField?.text = user?.phoneNumber
            case 4:
                cell.textField?.text = user?.company
            default:
                break
            
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}