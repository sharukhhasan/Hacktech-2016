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
    var phoneNumber: String?
    var company: String?
    var facebookUrl: String?
    var linkedinUrl: String?

    let arraySettings = ["First Name", "Last Name", "Email", "Phone Number", "Company", "Facebook Link", "Linkedin Link"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        user = try! context?.objectWithType("Person", identifier: id, forKey: "id") as! Person

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
        case 3:
            phoneNumber = sender.text
            break
        case 4:
            company = sender.text
            break
        case 5:
            facebookUrl = sender.text
            break
        case 6:
            linkedinUrl = sender.text
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

        if let phoneNumber = phoneNumber {
            user?.phoneNumber = phoneNumber
        }

        if let company = company {
            user?.company = company
        }

        if let facebookUrl = facebookUrl {
            user?.facebookUrl = facebookUrl
        }

        if let linkedinUrl = linkedinUrl {
            user?.linkedinUrl = linkedinUrl
        }

        try! context?.save()

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        switch sender.tag {
        case 0:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "firstNameOff")
            break
        case 1:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "lastNameOff")
            break
        case 2:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "emailOff")
            break
        case 3:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "phoneNumberOff")
            break
        case 4:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "companyOff")
            break
        case 5:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "facebookUrlOff")
            break
        case 6:
            NSUserDefaults.standardUserDefaults().setBool(!sender.on, forKey: "linkedinUrlOff")
            break
        default:
            print("Unknown switch.")
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell")! as! SettingsCell
        cell.backgroundColor = UIColor.clearColor()
        cell.nameLabel?.text = arraySettings[indexPath.row]
        cell.textField.tag = indexPath.row
        cell.uiSwitch.tag = indexPath.row

        switch indexPath.row {
        case 0:
            cell.textField?.text = user?.firstName
            cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("firstNameOff")
            break
        case 1:
            cell.textField?.text = user?.lastName
            cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("lastNameOff")
            break
        case 2:
            cell.textField?.text = user?.email
            cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("emailOff")
            break
        case 3:
            cell.textField?.text = user?.phoneNumber
            cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("phoneNumberOff")
            break
        case 4:
            cell.textField?.text = user?.company
            cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("companyOff")
            break
        case 5:
            cell.textField?.text = user?.facebookUrl
            cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("facebookUrlOff")
            break
        case 6:
            cell.textField?.text = user?.linkedinUrl
            cell.uiSwitch.on = !NSUserDefaults.standardUserDefaults().boolForKey("linkedinUrlOff")
            break

        default:
            print("Unknown index path.")
            break
        
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}