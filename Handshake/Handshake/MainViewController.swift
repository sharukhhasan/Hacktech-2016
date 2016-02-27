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

class MainViewController: UIViewController, ShakeHandlerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Person person;
        /* Usage: Initlize ShakeHandler with self as delegate (we added ShakeHandlerDelegate above). Then call sendPerson when needed. */
//        let shakeHandler = ShakeHandler(delegate: self)
//        shakeHandler.sendPerson(<#T##person: Person##Person#>, inside: <#T##NSManagedObjectContext#>)
        let shakeHandler = ShakeHandler(delegate: self)
        shakeHandler.sendPerson(person, managedObjectContext)
        
    }

    // MARK: ShakeHandlerDelegate

    func receivedPerson(person: Person) {
        print(person) // This is the person object received.
    }

}

