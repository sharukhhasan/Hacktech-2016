//
//  SettingsViewController.swift
//  Handshake
//
//  Created by Sharukh Hasan on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import Foundation
import CoreData

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var currentUserID: NSString = ""
    var user: Person?
    var context: NSManagedObjectContext?
    
    let arraySettings = ["First Name", "Last_Name", "Email", "Phone Number", "Company"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("UserEmail") as! String
        user = try! context?.objectWithType("Person", identifier: userEmail, forKey: "email") as! Person
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell")!
        
        switch indexPath.row {
            case 1:
                cell.textLabel?.text = user?.firstName
                break;
            case 2:
                cell.textLabel?.text = user?.lastName
                break;
            case 3:
                cell.textLabel?.text = user?.email
                break;
            case 4:
                cell.textLabel?.text = ""
                break;
            case 5:
                cell.textLabel?.text = ""
                break;
            default:
                cell.textLabel?.text = ""
            
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("DetailedViewSegue", sender: self)
    }
}