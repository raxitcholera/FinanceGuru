//
//  StockTransactions+CoreDataClass.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/10/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


public class StockTransactions: NSManagedObject {
    convenience init(dictionary: [String:Any], context: NSManagedObjectContext)
    {
        if let ent = NSEntityDescription.entity(forEntityName: "StockTransactions", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.action = dictionary["action"] as? String ?? "buy"
            self.qty = Int32((dictionary["qty"] as? String)!) ?? 0
            self.rate = Double((dictionary["last_price"] as? String)!) ?? 0
            self.date = NSDate()
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
}
