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
        
        user = try! context?.objectsWithType("Person") as? Person
        
        getUser()
    }
    
    func getUser(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                
                    if (error == nil){
                        self.currentUserID = result.valueForKey("id") as! NSString
                    }
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let person = people?[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell")!
        
        if let firstName = person?.firstName, lastName = person?.lastName {
            cell.textLabel?.text = firstName + " " + lastName
        }
        
        /*if let facebookUrl = person?.facebookUrl{
        cell.imageView?.setImageWithURL(facebookUrl)
        }
        
        if let linkedinUrl = person?.linkedinUrl{
        cell.imageView?.setImageWithURL(linkedinUrl)
        }
        
        if let email = person?.email{
        let url = NSURL(string: "mailto:\(email)")
        cell.imageView?.setImageWithURL(url)
        }*/
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("DetailedViewSegue", sender: self)
    }
}