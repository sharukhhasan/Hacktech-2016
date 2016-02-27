//
//  ConfirmViewController.swift
//  Handshake
//
//  Created by Marion Xu on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit
import AFNetworking
import CoreData
import ChameleonFramework
import QuartzCore
import CoreGraphics

class ConfirmViewController: UIViewController {

    var person: Person?
    var context: NSManagedObjectContext?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    //TODO: change these to nice pics of check mark and x if we have time
    //and put them on the same line :)

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "check-button-round") {
            confirmButton.setImage(image, forState: UIControlState.Normal)
        }
        if let image = UIImage(named: "check-button-round-clicked") {
            confirmButton.setImage(image, forState: UIControlState.Highlighted)
        }
        if let image = UIImage(named: "cancel-button-round") {
            cancelButton.setImage(image, forState: UIControlState.Normal)
        }
        if let image = UIImage(named: "cancel-button-round-clicked") {
            cancelButton.setImage(image, forState: UIControlState.Highlighted)
        }
        
        if let firstName = person?.firstName, let lastName = person?.lastName {
            titleLabel.text = "You just shook hands with \(firstName) \(lastName)!"
        }

        // TODO: replace this url with the profile pic link for the other user. :)
        if let url = NSURL(string: "https://i.imgur.com/Jvh1OQm.jpg") {
            profileImageView.setImageWithURL(url)
        }

        view.backgroundColor = GradientColor(.TopToBottom, frame: view.frame, colors: [UIColor.flatSkyBlueColor(), UIColor.flatBlueColorDark()])
    }

    @IBAction func confirmButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        do {
            if let unwrappedPerson = self.person {
                self.context?.deleteObject(unwrappedPerson)
                try self.context?.save()
            }
        } catch let error as NSError {
            print("Unable to delete person: \(error.localizedDescription)")
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
}
