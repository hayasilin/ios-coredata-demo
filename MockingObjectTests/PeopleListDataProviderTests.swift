//
//  PeopleListDataProviderTests.swift
//  MockingObjectTests
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import XCTest
import CoreData
@testable import MockingObject

// Fakes
class PeopleListDataProviderTests: XCTestCase {
    var storeCoordinator: NSPersistentStoreCoordinator!
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: NSManagedObjectModel!
    var store: NSPersistentStore!
    
    var dataProvider: PeopleListDataProvider!
    
    var tableView: UITableView!
    var testRecord: PersonInfo!

    override func setUp() {
        super.setUp()
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            store = try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print(error)
        }
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        
        dataProvider = PeopleListDataProvider()
        dataProvider.managedObjectContext = managedObjectContext
        dataProvider.setUpCoreData()
        
        let viewController = PeopleListTableViewController()
        viewController.dataProvider = dataProvider
        tableView = viewController.tableView
        
        testRecord = PersonInfo(firstName: "TestFirstName", lastName: "TestLastName", birthday: NSDate())
    }

    override func tearDown() {
        super.tearDown()
        managedObjectContext = nil
        
        do {
            try storeCoordinator.remove(store)
        } catch {
            print(error)
        }
    }

    func testThatStoreIsSetUp() {
        XCTAssertNotNil(store, "no persistent store")
    }
    
    func testOnePersonInThePersistantStoreResultsInOneRow() {
        dataProvider.addPerson(personInfo: testRecord)
        
        XCTAssertEqual(tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 0), 1, "After adding one person number of rows is not 1")
    }
}
