//
//  ConfirmViewController.swift
//  Handshake
//
//  Created by Marion Xu on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    //TODO: change these to nice pics of check mark and x if we have time
    //and put them on the same line :)
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: replace {{Name}} with the name of the user you just shook hands with
        nameLabel.text = "You just shook hands with " + "{{Name}}" + "!"
        
        //TODO: replace this url with the profile pic link for the other user. :)
        let urlString = "https://trip101.com/assets/default_profile_pic-9c5d869a996318867438aa3ccf9a9607daee021047c1088645fbdfbbed0e2aec.jpg"
        
        let imgURL: NSURL = NSURL(string: urlString)!
        
        // Download an NSData representation of the image at the URL
        let request: NSURLRequest = NSURLRequest(URL: imgURL)

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
            
            if ((error == nil)) {
                
                //var imgData: NSData = NSData(contentsOfURL: imgURL)
                let image = UIImage(data: data!)
                
                self.profilePic.image = image
                
            }
            else {
                print("Error: \(error!.localizedDescription)")
            }
        })
    }
    
    @IBAction func confirmButtonClicked(sender: AnyObject) {
        //Shake was successful. Confirm the data saving and then 
        //segue to the shaking screen again.
        
        performSegueWithIdentifier("toNewShake", sender: nil)
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        //Shake was wrong person/unsuccessful/sender changed mind.
        //Abort the data saving and segue to the shake screen again.
        
        performSegueWithIdentifier("toNewShake", sender: nil)
    }
}
