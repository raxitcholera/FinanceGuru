//
//  StocksTableViewController.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/3/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import CoreData

class StocksTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoreDataManagerDelegate {

    var selectedPortfolio:Portfolio?
    private var stockArray: [Stock]!
    private var tempStockArray:[Stock]!
    var UserAction:stockAction?
    private var downloadedStocks = [[String:Any]]()
    var refreshControl: UIRefreshControl!
    
    var searchTask: URLSessionDataTask?
    
    @IBOutlet weak var stockTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addStockClicked))
        
//        stockArray = selectedPortfolio?.stocks?.allObjects as? [Stock] ?? [Stock]()
        CoreDataManager.sharedManager.delegate = self
        
        let portfolioStocks:NSSet = (selectedPortfolio?.stocks)!
        portfolioStocks.filtered(using: NSPredicate(format:"qty >= 0"))
        stockArray = portfolioStocks.allObjects as? [Stock] ?? [Stock]()
        if(stockArray.count == 0)
        {
            loadStocks()
        }
//        title = "\(String(describing: selectedPortfolio?.portfolio_name!))'s Stocks"
        title = "Portfolio Stocks"
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(StocksTableViewController.refreshView), for: UIControlEvents.valueChanged)
        stockTableView.addSubview(refreshControl)
        
        
    }

    @objc func refreshView()
    {
        stockArray = selectedPortfolio?.stocks?.allObjects as! [Stock]
        performOnMainthread {
            self.stockTableView.reloadData()
        }
        //Add the call to google here to update the stock price to coredata
        refreshControl.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        guard selectedPortfolio != nil else {
            showAlertwith(title: "Portfolio Info Missing", message: "Please Select or add one ", vc: self)
            performOnMainthread {
                _ = self.navigationController?.popViewController(animated: true)
            }
            return
            
        }
        refreshView()
        
    }
    
    @objc private func addStockClicked(){
        performOnMainthread {
            let stockSearchView = self.storyboard?.instantiateViewController(withIdentifier: "stockSearchView") as! TickerPickerViewController
            stockSearchView.selectedPortfolio = self.selectedPortfolio
            self.navigationController?.pushViewController(stockSearchView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stockArray.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let sell = UITableViewRowAction(style: .destructive, title: "Sell") { (action, indexPath) in
            self.UserAction = stockAction.sell
            self.gotoDetailView(selectedStock: self.stockArray[(indexPath as NSIndexPath).row])
        }
        
        let buy = UITableViewRowAction(style: .normal, title: "Buy") { (action, indexPath) in
            self.UserAction = stockAction.buy
            self.gotoDetailView(selectedStock: self.stockArray[(indexPath as NSIndexPath).row])
        }
        
        buy.backgroundColor = UIColor.green
        
        return [buy, sell]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performOnMainthread {
            let stockTransactionTableView = self.storyboard?.instantiateViewController(withIdentifier: "stockTransactionViewController") as! StockTransactionTableViewController
            stockTransactionTableView.selectedStock = self.stockArray[indexPath.row]
            self.navigationController?.pushViewController(stockTransactionTableView, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockTableViewCell

        // Configure the cell...
        if(stockArray.count > indexPath.row){
            cell.companyNameLbl.text = stockArray[indexPath.row].stockname
            cell.costbasisLbl.text = "\(stockArray[indexPath.row].costbasisusd)"
            cell.UnitsLbl.text = "\(stockArray[indexPath.row].qty)"
            cell.gainLbl.text = "\(stockArray[indexPath.row].gain)"
            cell.gainPercentLbl.text = "\(stockArray[indexPath.row].gain_percent)"
        }

        return cell
    }
    
    func loadStocks(){
        startNetworkinUseIndicator()
        CoreDataManager.sharedManager.currentPortfolio = selectedPortfolio
        client.sharedInstance.updateStockInformation { (responseData, error) in
            guard error == nil else {
                showAlertwith(title: "Error Connection to Server to update", message: "Check if you have internet connection", vc: self)
                return
            }
            guard let response = responseData as? NSDictionary else {
                showAlertwith(title: "Response from Server was Not recognisable", message: "Something went wrong", vc: self)
                return
            }
            if response.value(forKey: Constants.ResponseKeys.Status) as! String == Constants.ResponseKeys.Fail {
                showAlertwith(title: "Response from Server was an error Message", message: response.value(forKey: Constants.ResponseKeys.Message) as? String, vc: self)
                return
            }
            self.downloadedStocks = response.value(forKey: Constants.ResponseKeys.StocksInfo)  as! [[String:Any]]
            stopNetworkinUseIndicator()
            for i in 0 ..< self.downloadedStocks.count{
                CoreDataManager.sharedManager.addStock(dictionary: self.downloadedStocks[i])
            }
            self.dbStack.save()
            self.refreshView()
        }
    
    }
    
    func refreshStockGainFor(tickers:[String]) {
        
//        tempStockArray = selectedPortfolio?.stocks?.allObjects as! [Stock]
        
        startNetworkinUseIndicator()
        
        searchTask = client.sharedInstance.getTickerGainForTicker(tickers) { (stockLastPrice, error) in
            self.searchTask = nil
            stopNetworkinUseIndicator()
            guard error == nil else{
                //showAlertwith(title: "Google finance error", message: "Something went wrong fetching the last price", vc: self)
                return
            }
        }
    }
    
    func gotoDetailView(selectedStock:Stock) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "StockDetailViewController") as! StockDetailViewController
        controller.stock = YAHOOTickers.tickerFromStock(selectedStock)
        controller.selectedPortfolio = selectedPortfolio
        controller.selectedStock = selectedStock
        controller.action = UserAction
        performOnMainthread {
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }

}
