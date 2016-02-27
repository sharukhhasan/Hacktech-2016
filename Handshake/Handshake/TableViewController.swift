//
//  TableViewController.swift
//  Handshake
//
//  Created by Marion Xu on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
        
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
    
    func returnArr(returnArray: Array<String>) -> Array<String>{
        let returnArray = ["sharukh-hasan@uiowa.edu", "sharukh", "hasan", "google", "6306294934", "http://www.facebook.com", "http://www.linkedin.com"]
        
        return returnArray
    }
    
    var fetchedResultsController: NSFetchedResultsController{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: delegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        // Configure Fetched Results Controller
        return fetchedResultsController
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let person = fetchedResultsController.objectAtIndexPath(indexPath) as! Person
        
        let cell = tableView.dequeueReusableCellWithIdentifier("personCell")!
        
        let firstName = String(person.firstName!)
        let lastName = String(person.lastName!)
        let fullName = firstName + " " + lastName
        cell.textLabel?.text = fullName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        default: break
        }
    }
    
}