//
//  PortfolioUser+CoreDataProperties.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/5/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


extension PortfolioUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortfolioUser> {
        return NSFetchRequest<PortfolioUser>(entityName: "PortfolioUser")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var userID: String?
    @NSManaged public var username: String?
    @NSManaged public var portfolios: NSSet?

}

// MARK: Generated accessors for portfolios
extension PortfolioUser {

    @objc(addPortfoliosObject:)
    @NSManaged public func addToPortfolios(_ value: Portfolio)

    @objc(removePortfoliosObject:)
    @NSManaged public func removeFromPortfolios(_ value: Portfolio)

    @objc(addPortfolios:)
    @NSManaged public func addToPortfolios(_ values: NSSet)

    @objc(removePortfolios:)
    @NSManaged public func removeFromPortfolios(_ values: NSSet)

}
