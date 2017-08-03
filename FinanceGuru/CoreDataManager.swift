//
//  CoreDataManager.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/4/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataManagerDelegate: NSObjectProtocol
{
    func refreshView()
}

class CoreDataManager: NSObject {

    
    static let sharedManager = CoreDataManager()
    var currentUser:PortfolioUser!
    var currentPortfolio:Portfolio?
    
    weak var delegate: CoreDataManagerDelegate?
    
    override private init()
    {
        super.init()
    }
    
    func addUser(dictionary: [String:Any])->PortfolioUser
    {
        let portfolioUser = PortfolioUser(dictionary: dictionary, context: dbStack.context)
        dbStack.save()
        
        return portfolioUser
    }
    
    func addPortfolio(dictionary:[String:Any])
    {
        let currentPortfolio = Portfolio(dictionary: dictionary, context: dbStack.context)
        appDelegate.loggedinUser?.addToPortfolios(currentPortfolio)
        dbStack.save()
        
    }
    
    func removePortfolio(portfolio:Portfolio)
    {
        appDelegate.loggedinUser?.removeFromPortfolios(portfolio)
        dbStack.save()
        
    }
    
    func addStock(dictionary:[String:Any])
    {
        let currentStock = Stock(dictionary: dictionary, context: dbStack.context)
        let currentStockTransaction = StockTransactions(dictionary: dictionary, context: dbStack.context)
        currentStock.addToTransaction(currentStockTransaction)
        currentPortfolio?.addToStocks(currentStock)
        
    }
    func updateStock(stock:Stock, price:Double, qty:Int, action:stockAction)
    {
        let differenceValue = Double(qty)*price
        var dictionary = [String:AnyObject]()
        dictionary["last_price"] = String(price) as AnyObject
        dictionary["qty"] = String(qty) as AnyObject
        
            if( action==stockAction.sell && stock.qty >= Int32(qty))
            {
                
                dictionary["action"] = "sell" as AnyObject
                
                stock.setValue(stock.qty-Int32(qty), forKey: "qty")
                stock.setValue(stock.costbasisusd + Double(differenceValue), forKey: "costbasisusd")
                let currentStockTransction = StockTransactions(dictionary: dictionary, context: dbStack.context)
                stock.addToTransaction(currentStockTransction)
                
                
            } else if (action == stockAction.buy)
            {
                dictionary["action"] = "buy" as AnyObject
                stock.setValue(stock.qty+Int32(qty), forKey: "qty")
                stock.setValue(stock.costbasisusd - Double(differenceValue), forKey: "costbasisusd")
                let currentStockTransction = StockTransactions(dictionary: dictionary, context: dbStack.context)
                stock.addToTransaction(currentStockTransction)
            }
        
        

        dbStack.save()
        
    }
    
    
}
