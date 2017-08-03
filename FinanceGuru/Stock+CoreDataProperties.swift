//
//  Stock+CoreDataProperties.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/10/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var costbasis: Double
    @NSManaged public var costbasisusd: Double
    @NSManaged public var gain: Double
    @NSManaged public var gain_percent: Double
    @NSManaged public var lastPrice: Double
    @NSManaged public var qty: Int32
    @NSManaged public var sid: Int32
    @NSManaged public var stock_deleted: Bool
    @NSManaged public var stockname: String?
    @NSManaged public var ticker: String?
    @NSManaged public var portfolio: Portfolio?
    @NSManaged public var transaction: NSSet?

}

// MARK: Generated accessors for transaction
extension Stock {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransaction(_ value: StockTransactions)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransaction(_ value: StockTransactions)

    @objc(addTransaction:)
    @NSManaged public func addToTransaction(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransaction(_ values: NSSet)

}
