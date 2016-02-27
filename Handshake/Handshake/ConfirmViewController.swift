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
    
    //TODO: change these to nice pics of check mark and x if we have time
    //and put them on the same line :)
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "You just shook hands with " + "{{Name}}" + "!"
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
