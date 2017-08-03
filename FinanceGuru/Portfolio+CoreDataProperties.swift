//
//  Portfolio+CoreDataProperties.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/5/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


extension Portfolio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Portfolio> {
        return NSFetchRequest<Portfolio>(entityName: "Portfolio")
    }

    @NSManaged public var created_dt: NSDate?
    @NSManaged public var pid: Int32
    @NSManaged public var portfolio_deleted: Bool
    @NSManaged public var portfolio_name: String?
    @NSManaged public var stock_count: Int32
    @NSManaged public var portfoliouser: PortfolioUser?
    @NSManaged public var stocks: NSSet?

}

// MARK: Generated accessors for stocks
extension Portfolio {

    @objc(addStocksObject:)
    @NSManaged public func addToStocks(_ value: Stock)

    @objc(removeStocksObject:)
    @NSManaged public func removeFromStocks(_ value: Stock)

    @objc(addStocks:)
    @NSManaged public func addToStocks(_ values: NSSet)

    @objc(removeStocks:)
    @NSManaged public func removeFromStocks(_ values: NSSet)

}
