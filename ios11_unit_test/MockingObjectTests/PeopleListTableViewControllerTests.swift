//
//  PeopleListTableViewControllerTests.swift
//  MockingObjectTests
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import XCTest
import CoreData
import ContactsUI
@testable import MockingObject

// Mocks
class PeopleListTableViewControllerTests: XCTestCase {
    var viewController: PeopleListTableViewController!
    
    override func setUp() {
        viewController = PeopleListTableViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDataProviderHasTableViewPropertySetAfterLoading() {
        // given
        let mockDataProvider = MockDataProvider()
        viewController.dataProvider = mockDataProvider
        
        // when
        XCTAssertNil(mockDataProvider.tableView, "Before loading the table view should be nil")
        let _ = viewController.view
        
        // then
        XCTAssertTrue(mockDataProvider.tableView != nil, "The table view should be set")
        XCTAssert(mockDataProvider.tableView === viewController.tableView,
                  "The table view should be set to the table view of the data source")
    }
    
    func testCallsAddPersonOfThePeopleDataSourceAfterAddingAPersion() {
        // given
        let mockDataSource = MockDataProvider()
        viewController.dataProvider = mockDataSource
        
        // when
        let contact = CNMutableContact()
        contact.givenName = "TestFirstname"
        contact.familyName = "TestLastname"
        var dateComponents = DateComponents()
        dateComponents.year = 1980
        dateComponents.month = 7
        dateComponents.day = 11
        dateComponents.hour = 8
        dateComponents.minute = 34
        dateComponents.timeZone = .current
        contact.birthday = dateComponents

        viewController.contactPicker(CNContactPickerViewController(), didSelect: contact)
    
        // then
        XCTAssert(mockDataSource.addPersonGotCalled, "addPerson should have been called")
    }
    
    func testSortingCanBeChanged() {
        // given
        let mockUserDefaults = MockUserDefaults(suiteName: "testing")!
        viewController.userDefaults = mockUserDefaults
        
        // when
        let segmentedControl = UISegmentedControl()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(viewController, action: #selector(viewController?.changeSorting(sender:)), for: .valueChanged)
        segmentedControl.sendActions(for: .valueChanged)
        
        // then
        XCTAssertTrue(mockUserDefaults.sortWasChanged, "Sort value in user defaults should be altered")
    }
}

class MockDataProvider: NSObject, PeopleListDataProviderProtocol {
    var addPersonGotCalled = false
    
    var managedObjectContext: NSManagedObjectContext?
    
    weak var tableView: UITableView!
    
    func addPerson(personInfo: PersonInfo) {
        addPersonGotCalled = true
    }
    
    func fetch() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

class MockUserDefaults: UserDefaults {
    var sortWasChanged = false
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == "sort" {
            sortWasChanged = true
        }
    }
}
