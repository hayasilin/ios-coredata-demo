//
//  ManagedToken.swift
//  CoreDataDemo
//
//  Created by kuanwei on 2021/4/21.
//  Copyright © 2021 kuanwei. All rights reserved.
//

import Foundation
import CoreData

@objc(Token)
class ManagedToken: NSManagedObject {
    public static let entityName = "Token"

    public enum Attribute: String {
        public typealias ManagedObject = ManagedToken

        case tokenId
        case encryptedToken
        case expirationDate
    }

    // MARK: - Properties

    @NSManaged public var tokenId: String

    @NSManaged public var encryptedToken: Data?

    @NSManaged public var expirationDate: Int64

    // MARK: - Relationships
}
