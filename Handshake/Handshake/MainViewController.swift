//
//  MainViewController.swift
//  Handshake
//
//  Created by Justin Jia on 2/26/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit
import PGMappingKit

class MainViewController: UIViewController, ShakeHandlerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Usage: Initlize ShakeHandler with self as delegate (we added ShakeHandlerDelegate above). Then call sendPerson when needed. */

        let shakeHandler = ShakeHandler(delegate: self)

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let person = delegate.managedObjectContext.save(["firstName": "Justin", "lastName": "Jia", "email": "justin.jia@icloud.com"], description: shakeHandler.mapping, error: nil) as! Person

        shakeHandler.sendPerson(person, inside: delegate.managedObjectContext)
    }

    // MARK: ShakeHandlerDelegate

    func receivedPerson(person: Person) {
        print(person) // This is the person object received.
    }

}

