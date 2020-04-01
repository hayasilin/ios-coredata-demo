//
//  PersonInfo.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import Foundation
import ContactsUI

struct PersonInfo {
    let firstName: String
    let lastName: String
    let birthday: NSDate
    
    init(firstName: String, lastName: String, birthday: NSDate) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
    
    init(contact: CNContact) {
        firstName = contact.givenName
        lastName = contact.familyName
        let userCalendar = Calendar.current
        let someDateTime = userCalendar.date(from: contact.birthday!)
        birthday = someDateTime! as NSDate
    }
}
