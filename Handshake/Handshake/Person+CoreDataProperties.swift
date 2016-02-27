//
//  Person+CoreDataProperties.swift
//  Handshake
//
//  Created by Justin Jia on 2/26/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var email: String?

}
