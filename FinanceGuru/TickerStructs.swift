//
//  TickerStructs.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/8/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

struct YAHOOTickers {
    
    // MARK: Properties
    
    let ticker: String
    let companyname: String
    
    init(dictionary: [String:AnyObject]) {
        ticker = dictionary[Constants.yahooResponseKeys.Ticker] as! String
        companyname = dictionary[Constants.yahooResponseKeys.CompanyName] as! String
    }
    
    static func tickerFromStock(_ stock:Stock) -> YAHOOTickers{
        var tickerData = [String:AnyObject]()
        tickerData[Constants.yahooResponseKeys.Ticker] = stock.ticker as AnyObject
        tickerData[Constants.yahooResponseKeys.CompanyName] = stock.stockname as AnyObject
        return YAHOOTickers(dictionary: tickerData)
        
    }
    static func tickersFromResults(_ results: [[String:AnyObject]]) -> [YAHOOTickers] {
        
        var tickers = [YAHOOTickers]()
        for result in results {
            tickers.append(YAHOOTickers(dictionary: result))
        }
        return tickers
    }
    
}

struct GoogleTickers {
    let lastPrice:String
    let ticker:String
    
    init(dictionary: [String:AnyObject]) {
        lastPrice = dictionary["l_fix"] as! String
        ticker = dictionary["t"] as! String
    }
    
    static func priceFromResults(_ results:[[String:AnyObject]]) -> [GoogleTickers]{
        var tickers = [GoogleTickers]()
        for ressult in results {
            tickers.append(GoogleTickers(dictionary: ressult))
        }
        return tickers
    }
}


