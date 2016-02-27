//
//  TableViewController.swift
//  Handshake
//
//  Created by Marion Xu on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit
import CoreData
import PGMappingKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var people: [Person]?
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        people = try! context?.objectsWithType("Person") as? [Person]

        tableView.reloadData()
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                dismissViewControllerAnimated(true, completion: nil)
                break

            case UISwipeGestureRecognizerDirection.Left:
                dismissViewControllerAnimated(true, completion: nil)
                break
            default:
                break
            }
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
        
        if let facebookUrl = person?.facebookUrl{
            cell.imageView?.setImageWithURL(facebookUrl)
        }
        
        if let linkedinUrl = person?.linkedinUrl{
            cell.imageView?.setImageWithURL(linkedinUrl)
        }
        
        if let email = person?.email{
            let url = NSURL(string: "mailto:\(email)")
            cell.imageView?.setImageWithURL(url)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("DetailedViewSegue", sender: self)
    }
        
}