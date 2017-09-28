//
//  TickerPickerViewController.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/8/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit

protocol TickerPickerViewControllerDelegate {
    func tickerPicker(_ tickerPicker: TickerPickerViewController, didPickMovie movie: YAHOOTickers?)
}


class TickerPickerViewController: UIViewController {

    
    var tickers = [YAHOOTickers]()
    var selectedPortfolio:Portfolio?
    var searchTask: URLSessionDataTask?
    var delegate: TickerPickerViewControllerDelegate?
    
    
    @IBOutlet weak var tickerTableView: UITableView!
    @IBOutlet weak var tickerSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        title = "Search Stock Name"
        
    }

    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func cancel() {
        delegate?.tickerPicker(self, didPickMovie: nil)
        
    }

}



extension TickerPickerViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let task = searchTask {
            task.cancel()
        }

        if searchText == "" {
            tickers = [YAHOOTickers]()
            tickerTableView?.reloadData()
            return
        }
        
        // new search
        startNetworkinUseIndicator()
        searchTask = client.sharedInstance.getTickersForSearchString(searchText) { (tickers, error) in
            self.searchTask = nil
            stopNetworkinUseIndicator()
            guard error == nil else {
                showAlertwith(title: "Search Failed", message: error?.localizedDescription, vc: self)
                return
            }
            
            if let tickers = tickers {
                self.tickers = tickers
                performOnMainthread {
                    self.tickerTableView!.reloadData()
                }
            }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension TickerPickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return tickerSearchBar.isFirstResponder
    }
}

extension TickerPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellReuseId = "TickerSearchCell"
        let ticker = tickers[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId) as UITableViewCell!
        
        cell?.textLabel?.text = ticker.companyname
        cell?.detailTextLabel?.text = ticker.ticker
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ticker = tickers[(indexPath as NSIndexPath).row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "StockDetailViewController") as! StockDetailViewController
        controller.stock = ticker
        controller.selectedPortfolio = selectedPortfolio
        controller.action = stockAction.buy
        performOnMainthread {
            self.navigationController!.pushViewController(controller, animated: true)
        }
        
    }
}

