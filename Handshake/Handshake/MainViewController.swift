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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shakeHandler = ShakeHandler(delegate: self)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let person = delegate.managedObjectContext.save(["firstName": "Justin", "lastName": "Jia", "email": "justin.jia@icloud.com"], description: shakeHandler.mapping, error: nil) as! Person
    
        shakeHandler.sendPerson(person, inside: delegate.managedObjectContext)

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

    // MARK: Motion

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if (motion == .MotionShake) {

        }
    }

    // MARK: Gesture

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
                performSegueWithIdentifier("PastSegue", sender: nil)
                break
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
                performSegueWithIdentifier("PastSegue", sender: nil)
                break
            default:
                break
            }
        }
    }


    // MARK: ShakeHandlerDelegate

    func receivedPerson(person: Person) {
        print(person) // This is the person object received.
    }
    
    

}

