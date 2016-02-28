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
import ChameleonFramework
import QuartzCore
import CoreGraphics
import SafariServices
import MessageUI

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var people: [Person]?
    var context: NSManagedObjectContext?
    var onClickCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        people = try! context?.objectsWithType("Person") as? [Person]

        if let unwrappedPeople = people {
            let email = NSUserDefaults.standardUserDefaults().objectForKey("UserEmail") as! String
            for person in unwrappedPeople {
                if person.email == email {
                    if let index = people?.indexOf(person) {
                        people?.removeAtIndex(index)
                    }
                }
            }
        }

        tableView.reloadData()

        view.backgroundColor = GradientColor(.TopToBottom, frame: view.frame, colors: [UIColor.flatSkyBlueColor(), UIColor.flatBlueColorDark()])
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell") as! PersonCell
        cell.backgroundColor = UIColor.clearColor()

        switch onClickCount {
        case 0:
            if let firstName = person?.firstName, lastName = person?.lastName {
                cell.nameLabel?.text = firstName + " " + lastName
            } else {
                cell.nameLabel?.text = "Unknown Name"
            }
            break
        case 1:
            cell.nameLabel?.text = person?.phoneNumber ?? "Unknown Phone Number"
            break
        case 2:
            cell.nameLabel?.text = person?.company ?? "Unknown Company"
            break
        default:
            print("Unknown onClickCount")
            break
        }

        if let imageUrl = person?.imageUrl {
            if let url = NSURL(string: imageUrl) {
                cell.profileImageView?.setImageWithURL(url)
            }
        }

        cell.facebookButton.tag = indexPath.row
        cell.linkedinButton.tag = indexPath.row
        cell.emailButton.tag = indexPath.row

        cell.facebookButton.enabled = person?.facebookUrl != nil
        cell.linkedinButton.enabled = person?.linkedinUrl != nil
        cell.emailButton.enabled = person?.email != nil

        cell.profileImageView.layer.masksToBounds = true
        cell.profileImageView.layer.cornerRadius = min(cell.profileImageView.bounds.size.height, cell.profileImageView.bounds.size.width) / 2
        cell.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.profileImageView.layer.borderWidth = 2

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        onClickCount = (onClickCount + 1) % 3
        tableView.reloadData()
    }

    @IBAction func facebookButtonTapped(sender: UIButton) {
        let person = people?[sender.tag]
        if let facebookUrl = person?.facebookUrl {
            if let url = NSURL(string: facebookUrl) {
                let safari = SFSafariViewController(URL: url)
                presentViewController(safari, animated: true, completion: nil)
            }
        }
    }

    @IBAction func emailButtonTapped(sender: UIButton) {
        let person = people?[sender.tag]
        if let email = person?.email {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            presentViewController(mail, animated: true, completion: nil)
        }
    }

    @IBAction func linkedinButtonTapped(sender: UIButton) {
        let person = people?[sender.tag]
        if let linkedinUrl = person?.linkedinUrl {
            if let url = NSURL(string: linkedinUrl) {
                let safari = SFSafariViewController(URL: url)
                presentViewController(safari, animated: true, completion: nil)
            }
        }
    }

    // MFMailComposeViewControllerDelegate

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}