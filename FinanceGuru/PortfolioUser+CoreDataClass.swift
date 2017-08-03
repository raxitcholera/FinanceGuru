//
//  PortfolioUser+CoreDataClass.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/4/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


public class PortfolioUser: NSManagedObject {
    convenience init(dictionary: [String:Any], context: NSManagedObjectContext)
    {
        if let ent = NSEntityDescription.entity(forEntityName: "PortfolioUser", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.firstName = dictionary["pmo_fname"] as? String ?? ""
            self.lastName = dictionary["pmo_lname"] as? String ?? ""
            self.username = dictionary["pmo_username"] as? String ?? ""
//            self.uniqueKey = dictionary["pmo_password"] as? String ?? ""
            self.displayName = "\(dictionary["pmo_fname"] as? String ?? "") \(dictionary["pmo_lname"] as? String ?? "")"
            self.userID = dictionary["pmo_id"] as? String ?? ""
        }
            
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
}
