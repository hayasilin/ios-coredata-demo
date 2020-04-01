//
//  PersonInfo.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import Foundation
import AddressBookUI

struct PersonInfo {
    let firstName: String
    let lastName: String
    let birthday: NSDate
    
    init(firstName: String, lastName: String, birthday: NSDate) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
    
    init(abRecord: ABRecord) {
        firstName = ABRecordCopyValue(abRecord, kABPersonFirstNameProperty)?.takeRetainedValue() as! String
        lastName = ABRecordCopyValue(abRecord, kABPersonLastNameProperty)?.takeRetainedValue() as! String
        birthday = ABRecordCopyValue(abRecord, kABPersonBirthdayProperty)?.takeRetainedValue() as! NSDate
    }
}
