//
//  APICommunicatorProtocol.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import Foundation

protocol APICommunicatorProtocol {
    func getPeople() -> (Error?, [PersonInfo]?)
    func postPerson(personInfo: PersonInfo) -> Error?
}
