//
//  PeopleListDataProviderProtocol.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AddressBookUI

protocol PeopleListDataProviderProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get }
    var tableView: UITableView! { get set }
    
    func addPerson(personInfo: PersonInfo)
    func fetch()
}
