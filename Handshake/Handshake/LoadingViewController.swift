//
//  LoadingViewController.swift
//  Handshake
//
//  Created by Marion Xu on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    //to stop the indicator: activityIndicatorView.stopAnimating()
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check for the other shake here, and stop animating + segue to 
        //confirmation screen after.
        
    }
    
}

