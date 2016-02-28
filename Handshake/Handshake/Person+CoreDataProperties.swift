//
//  Person+CoreDataProperties.swift
//  Handshake
//
//  Created by Sharukh Hasan on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var id: String?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var company: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var facebookUrl: String?
    @NSManaged var linkedinUrl: String?
    @NSManaged var imageUrl: String?
    @NSManaged var createdAt: NSDate?

}
