//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by kuanwei on 2020/8/28.
//  Copyright © 2020 kuanwei. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int64
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var family: Family?

}
