//
//  Constants.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - Constants

struct Constants {
    
    // MARK: NJIT
    struct NJIT {
        static let APIScheme = "https"
        static let APIHost = "web.njit.edu"
        static let APIPath = "/~rmc48/cs673/SP1/api/"
    }
    
    struct YAHOO {
        static let APIScheme = "http"
        static let APIHost = "d.yimg.com"
        static let APIPath = "/autoc.finance.yahoo.com/"
    }
    
    struct GOOGLE {
        static let APIScheme = "http"
        static let APIHost = "finance.google.com"
        static let APIPath = "/finance/"
    }
    
    // MARK: Localhost
    struct LOCAL {
        static let APIScheme = "http"
        static let APIHost = "localhost"
        static let APIPath = "/~raxit/SP1/api/"
    }
    
    struct ParameterKeys {
            static let Query = "query"
            static let Region = "region"
            static let Language = "lang"
            static let Client = "client"
            static let GoogleQuery = "q"
    }
    struct yahooResponseKeys {
        static let Ticker = "symbol"
        static let CompanyName = "name"
    }
    
    
    struct Methods {
        static let AuthorizationURL = "user.login.php"
        static let CreateUser  = "user.register.php"
        static let UserStockList  = "user.stock.list.php"
        static let UserPortfolioList  = "user.portfolio.list.php"
        static let UserPortfolioAdd  = "user.portfolio.add.php"
        static let YahooTickerSearch = "autoc"
        static let GoogleStoclPrice = "info"
        //http://finance.google.com/finance/info?client=ig&q=NSE:AAPL
    }
    
    struct StockResponseKeys {
        static let Sid = "sid"
        static let Ticker = "ticker"
        static let StockName = "stockname"
        static let CostBasis = "costbasis"
        static let CostBasisUSD = "costbasisusd"
        static let StockUnits = "qty"
        static let Count = "count"
        
    }
    
    struct SessionResponseKeys {
        static let Authenticated = "authenticated"
        static let UserName = "pmo_username"
        static let FirstName = "pmo_fname"
        static let LastName = "pmo_lname"
        static let UserId = "pmo_id"
    }
    
    struct PortfolioResponseKeys {
        static let PortfolioID = "pid"
        static let PortfolioName = "portfolio_name"
        static let PortfolioCash = "portfolio_cash"
        static let PortfolioCreatedDate = "created_dt"
//        static let Total = ""
//        static let Total = ""
//        static let Total = ""
//        static let Total = ""
//        static let Total = ""
        
    }
    
    // MARK: NJIT Response Keys
    struct ResponseKeys {
        static let Status = "stat"
        static let StocksInfo = "stocks"
        static let SessionInfo = "session_info"
        static let PortfolioInfo = "portfolios"
        static let NewPortfolioInfo = "portfolio"
        static let Deleted = "deleted"
        static let Message = "message"
        static let Fail = "Fail"
        static let Success = "Success"
    }
    
    
}
