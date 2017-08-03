//
//  Stock+CoreDataClass.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/4/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


public class Stock: NSManagedObject {
    convenience init(dictionary: [String:Any], context: NSManagedObjectContext)
    {
        if let ent = NSEntityDescription.entity(forEntityName: "Stock", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.ticker = dictionary["ticker"] as? String ?? ""
            self.stockname = dictionary["stockname"] as? String ?? ""
            self.qty = Int32((dictionary["qty"] as? String)!) ?? 0
            self.costbasis = Double((dictionary["costbasis"] as? String)!) ?? 0
            self.costbasisusd = Double((dictionary["costbasisusd"] as? String)!) ?? 0
            self.stock_deleted = false
            self.sid = Int32((dictionary["sid"] as? String)!) ?? 0
            self.lastPrice = Double((dictionary["last_price"] as? String)!) ?? 0
            self.gain = Double((dictionary["gain"] as? String)!) ?? 0
            self.gain_percent = Double((dictionary["gain_percent"] as? String)!) ?? 0
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
    
}
