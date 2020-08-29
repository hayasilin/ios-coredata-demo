//
//  APICommunicatorTests.swift
//  MockingObjectTests
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import XCTest
@testable import MockingObject

// Stubs
class APICommunicatorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchingPeopleFromAPICallsAddPeople() {
        // given
        let viewController = PeopleListTableViewController()
        let mockDataProvider = MockDataProvider()
        viewController.dataProvider = mockDataProvider
        let mockCommunicator = MockAPICommunicator()
        mockCommunicator.allPersonInfo = [PersonInfo(firstName: "firstname", lastName: "lastname", birthday: NSDate())]
        viewController.communicator = mockCommunicator
        
        // when
        viewController.fetchPeopleFromAPI()
        
        // then
        XCTAssert(mockDataProvider.addPersonGotCalled, "addPerson should have been called")
    }
}

extension APICommunicatorTests {
    class MockAPICommunicator: APICommunicatorProtocol {
        var allPersonInfo = [PersonInfo]()
        var postPersonGotCalled = false
        
        func getPeople() -> (Error?, [PersonInfo]?) {
            return (nil, allPersonInfo)
        }
        
        func postPerson(personInfo: PersonInfo) -> Error? {
            postPersonGotCalled = true
            return nil
        }
    }
}
