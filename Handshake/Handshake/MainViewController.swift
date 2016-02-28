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
import UIView_Shake
import ChameleonFramework
import QuartzCore
import CoreGraphics
import BubbleTransition
import NVActivityIndicatorView

class MainViewController: UIViewController, ShakeHandlerDelegate, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    let transition = BubbleTransition()

    var shakeHandler: ShakeHandler!
    var receivedPerson: Person?
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        shakeHandler = ShakeHandler(delegate: self)

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = delegate.managedObjectContext

        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            if NSUserDefaults.standardUserDefaults().objectForKey("hasActivated") == nil {
                // First launch
                NSUserDefaults.standardUserDefaults().setObject("launched", forKey: "hasActivated")
                self.performSegueWithIdentifier("SettingsSegue", sender: self)
            }
        }

        view.backgroundColor = GradientColor(.TopToBottom, frame: view.frame, colors: [UIColor.flatSkyBlueColor(), UIColor.flatBlueColorDark()])
        indicatorView.type = .BallScaleMultiple
        indicatorView.color = UIColor.whiteColor()
    }

    override func viewWillAppear(animated: Bool) {
        let email = NSUserDefaults.standardUserDefaults().objectForKey("UserEmail")
        let person = try! context.objectWithType("Person", identifier: email, forKey: "email") as! Person

        shakeHandler.prepareToSend(person, inside: context)

        if let name = person.firstName {
            titleLabel.text = "Welcome, \(name)!"
        } else {
            titleLabel.text = "Welcome to Handshake!"
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConfirmSegue" {
            let destinationViewController = segue.destinationViewController as! ConfirmViewController
            destinationViewController.person = receivedPerson
            destinationViewController.context = context
            destinationViewController.transitioningDelegate = self
            destinationViewController.modalPresentationStyle = .Custom
            subtitleLabel.text = "Waiting for handshake..."
            indicatorView.stopAnimation()
        } else if segue.identifier == "PastSegue" {
            let destinationViewController = segue.destinationViewController as! TableViewController
            destinationViewController.context = context
        } else if segue.identifier == "SettingsSegue" {
            let destinationViewController = segue.destinationViewController as! SettingsViewController
            destinationViewController.context = context
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    // MARK: UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = indicatorView.center
        transition.bubbleColor = UIColor.flatSkyBlueColor()
        return transition
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = indicatorView.center
        transition.bubbleColor = UIColor.flatSkyBlueColor()
        return transition
    }

    // MARK: Motion

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if (motion == .MotionShake) {
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                for subview in self.view.subviews {
                    subview.shake()
                }
                self.subtitleLabel.text = "Searching for people..."
                self.shakeHandler.send()
                self.indicatorView.startAnimation()
            }
        }
    }

    // MARK: ShakeHandlerDelegate

    func receivedPerson(person: Person) {
        receivedPerson = person
        performSegueWithIdentifier("ConfirmSegue", sender: self)
    }
    
    func shakeTimeout() {
        subtitleLabel.text = "Waiting for handshake..."
        indicatorView.stopAnimation()
    }

}

