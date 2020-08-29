//
//  APICommunicator.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import Foundation

struct APICommunicator: APICommunicatorProtocol {
    func getPeople() -> (Error?, [PersonInfo]?) {
        return (nil, nil)
    }
    
    func postPerson(personInfo: PersonInfo) -> Error? {
        return nil
    }
}
