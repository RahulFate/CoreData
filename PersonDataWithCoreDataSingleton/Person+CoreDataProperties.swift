//
//  Person+CoreDataProperties.swift
//  PersonData
//
//  Created by Alok Upadhyay on 3/29/18.
//  Copyright © 2018 Alok. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var ssn: Int16

}
