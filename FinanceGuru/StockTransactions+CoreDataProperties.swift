//
//  StockTransactions+CoreDataProperties.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/10/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


extension StockTransactions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockTransactions> {
        return NSFetchRequest<StockTransactions>(entityName: "StockTransactions")
    }

    @NSManaged public var action: String?
    @NSManaged public var qty: Int32
    @NSManaged public var rate: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var stock: Stock?

}
