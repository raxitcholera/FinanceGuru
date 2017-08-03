//
//  Portfolio+CoreDataClass.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/4/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


public class Portfolio: NSManagedObject {
    convenience init(dictionary: [String:Any], context: NSManagedObjectContext)
    {
        if let ent = NSEntityDescription.entity(forEntityName: "Portfolio", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.portfolio_name = dictionary["portfolio_name"] as? String ?? ""
            self.created_dt =  getNsDateFromString(StringDate: dictionary["created_dt"] as! String)
            self.portfolio_deleted = false
            self.pid = Int32((dictionary["pid"] as? String)!) ?? 0
            if dictionary["stock_count"] != nil {
                self.stock_count = Int32((dictionary["stock_count"] as? String)!) ?? 0
            } else {
                self.stock_count = 0
            }
            
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
    
    func getNsDateFromString(StringDate:String)->NSDate
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-m-d HH:mm:ss"
        
        let ns_date1:NSDate = dateFormatter.date(from: StringDate) as NSDate? ?? NSDate()
        return ns_date1
    }
}
