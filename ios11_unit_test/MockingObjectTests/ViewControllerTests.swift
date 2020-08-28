//
//  ViewControllerTests.swift
//  MockingObjectTests
//
//  Created by kuanwei on 2020/4/3.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import XCTest
import CoreData
@testable import MockingObject

class ViewControllerTests: XCTestCase {
    var managedObjectModel: NSManagedObjectModel!
    var storeCoordinator: NSPersistentStoreCoordinator!
    var store: NSPersistentStore!
    var managedObjectContext: NSManagedObjectContext!
    
    let sut = ViewController()

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
        
        sut.loadViewIfNeeded()
        sut.viewContext = managedObjectContext
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
        XCTAssertNotNil(store)
    }
    
    func testInsertPersonData() {
        sut.insertPersonData()
        XCTAssertEqual(2, sut.queryPersonData().count)
    }
    
    func testQueryPersonData() {
        XCTAssertEqual(0, sut.queryPersonData().count)
        
        sut.insertPersonData()
        XCTAssertEqual(2, sut.queryPersonData().count)
    }
    
    func testQueryWithPredicate() {
        sut.insertPersonData()
        XCTAssertEqual(1, sut.queryWithPredicate().count)
    }
    
    func testDeletePersonsOneByOne() {
        sut.insertPersonData()
        sut.deletePersonsOneByOne()
        XCTAssertEqual(0, sut.queryPersonData().count)
    }
}
