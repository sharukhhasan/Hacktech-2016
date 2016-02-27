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

class MainViewController: UIViewController, ShakeHandlerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!


    var shakeHandler: ShakeHandler!
    var receivedPerson: Person?
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        shakeHandler = ShakeHandler(delegate: self)

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = delegate.managedObjectContext

        let person = context.save(["firstName": "Justin", "lastName": "Jia", "email": "justin.jia@icloud.com"], description: shakeHandler!.mapping, error: nil) as! Person

        shakeHandler.prepareToSend(person, inside: context)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)

        if let name = person.firstName {
            titleLabel.text = "Welcome, \(name)"
        } else {
            titleLabel.text = "Welcome to Handshake!"
        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConfirmSegue" {
            let destinationViewController = segue.destinationViewController as! ConfirmViewController
            destinationViewController.person = receivedPerson
            destinationViewController.context = context
        } else if segue.identifier == "PastSegue" {
            let destinationViewController = segue.destinationViewController as! TableViewController
            destinationViewController.context = context
        }
    }

    // MARK: Motion

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if (motion == .MotionShake) {
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                self.subtitleLabel.text = "Searching for people..."
                self.shakeHandler.send()
            }
        }
    }

    // MARK: Gesture

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
                performSegueWithIdentifier("PastSegue", sender: self)
                break
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
                performSegueWithIdentifier("PastSegue", sender: self)
                break
            default:
                break
            }
        }
    }


    // MARK: ShakeHandlerDelegate

    func receivedPerson(person: Person) {
        receivedPerson = person
        performSegueWithIdentifier("ConfirmSegue", sender: self)
    }
    
    

}

