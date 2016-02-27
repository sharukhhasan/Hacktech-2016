//
//  MainViewController.swift
//  Handshake
//
//  Created by Justin Jia on 2/26/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, ShakeHandlerDelegate{
    let ReuseIdentifierToDoCell = "Person"
    @IBOutlet weak var tableView: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            print("hello")
            try self.fetchedResultsController.performFetch()
        } catch {
            print("shit")
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        let shakeHandler = ShakeHandler(delegate: self)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let person = delegate.managedObjectContext.save(["firstName": "Justin", "lastName": "Jia", "email": "justin.jia@icloud.com"], description: shakeHandler.mapping, error: nil) as! Person
    
        shakeHandler.sendPerson(person, inside: delegate.managedObjectContext)
    }

    // MARK: ShakeHandlerDelegate

    func receivedPerson(person: Person) {
        print(person) // This is the person object received.
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
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! Person
                //configureCell(cell, atIndexPath: indexPath)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifierToDoCell, forIndexPath: indexPath) as! ToDoCell
        
        // Configure Table View Cell
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: ToDoCell, atIndexPath indexPath: NSIndexPath) {
        // Fetch Record
        let record = fetchedResultsController.objectAtIndexPath(indexPath)
        
        // Update Cell
        if let name = record.valueForKey("name") as? String {
            cell.nameLabel.text = name
        }
        
        if let done = record.valueForKey("done") as? Bool {
            cell.doneButton.selected = done
        }
    }*/

}

