//
//  MainViewController.swift
//  Handshake
//
//  Created by Justin Jia on 2/26/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ShakeHandlerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Usage: Initlize ShakeHandler with self as delegate (we added ShakeHandlerDelegate above). Then call sendPerson when needed. */
//        let shakeHandler = ShakeHandler(delegate: self)
//        shakeHandler.sendPerson(<#T##person: Person##Person#>, inside: <#T##NSManagedObjectContext#>)
    }

    // MARK: ShakeHandlerDelegate

    func receivedPerson(person: Person) {
        print(person) // This is the person object received.
    }

}

