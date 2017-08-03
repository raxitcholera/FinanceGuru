//
//  StockTransactionTableViewController.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/10/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit

class StockTransactionTableViewController: UIViewController {

    var selectedStock:Stock?
    var stockTransactions:[StockTransactions]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        title = "Transactions"
        stockTransactions = selectedStock?.transaction?.allObjects as? [StockTransactions] ?? [StockTransactions]()
    }

}
extension StockTransactionTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stockTransactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactioncell", for: indexPath)

        if(stockTransactions.count > indexPath.row){
            cell.textLabel?.text = "\(stockTransactions[indexPath.row].action!) \(stockTransactions[indexPath.row].qty) @ \(stockTransactions[indexPath.row].rate)"
            cell.detailTextLabel?.text = "\(stockTransactions[indexPath.row].date!)"
        }

        return cell
    }

}
