//
//  WelcomeViewController.swift
//  Handshake
//
//  Created by Marion Xu on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set text to be name of logged in user from FB
        welcomeName.text = "Welcome, " + "{{Name}}" + "!"
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
                performSegueWithIdentifier("shakeToTableRight", sender: nil)
                break
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
                performSegueWithIdentifier("shakeToTableLeft", sender: nil)
                break
            default:
                break
            }
        }
    }
    
}
