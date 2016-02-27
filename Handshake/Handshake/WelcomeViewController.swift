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
    }
    
}
