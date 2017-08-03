//
//  PortfolioTableViewController.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/3/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import FirebaseAuth

class PortfolioTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CoreDataManagerDelegate {

    
    private var portfolioArray: [Portfolio]!
    private var downloadedPortfolios = [[String:Any]]()
    @IBOutlet weak var portfolioTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .reply, target: self, action: #selector(logoutClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addPortfolioClicked))
        self.navigationController?.isNavigationBarHidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        portfolioArray = appDelegate.loggedinUser?.portfolios?.allObjects as? [Portfolio] ?? [Portfolio]()
        
        CoreDataManager.sharedManager.delegate = self
        
        if(appDelegate.loggedinUser?.portfolios?.allObjects.count == 0)
        {
            loadPortfolios()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        guard appDelegate.loggedinUser != nil else {
            showAlertwith(title: "User Information Missing", message: "Please Login First", vc: self)
            logoutClicked()
            return
            
        }
        refreshView()
        
        
    }

    func refreshView()
    {
        portfolioArray = appDelegate.loggedinUser?.portfolios?.allObjects as! [Portfolio]
        performOnMainthread {
            self.portfolioTableView.reloadData()
        }
    }
    
    @objc private func logoutClicked()
    {
        let firebaseAuth = Auth.auth()
        do {
            
            try firebaseAuth.signOut()
            appDelegate.loggedinUser = nil
            _ = self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @objc private func addPortfolioClicked(){
        performOnMainthread {
            let stockTabView = self.storyboard?.instantiateViewController(withIdentifier: "addPortfolioVC") as! AddPortfolioViewController
            self.navigationController?.pushViewController(stockTabView, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return portfolioArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath)
        
        if(portfolioArray.count > indexPath.row){
            cell.textLabel?.text = portfolioArray[indexPath.row].portfolio_name!
            cell.detailTextLabel?.text = "\(portfolioArray[indexPath.row].stocks!.count)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performOnMainthread {
            let stockTableView = self.storyboard?.instantiateViewController(withIdentifier: "stockViewController") as! StocksTableViewController
            stockTableView.selectedPortfolio = self.portfolioArray[indexPath.row]
            self.navigationController?.pushViewController(stockTableView, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            CoreDataManager.sharedManager.removePortfolio(portfolio: portfolioArray[indexPath.row])
            refreshView()
            
        } else {
            print("Unhandled editing style! %d", editingStyle);
        }
    }
        
    func loadPortfolios(){
        startNetworkinUseIndicator()
        client.sharedInstance.updatePortfolioInformation { (responseData, error) in
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
            self.downloadedPortfolios = response.value(forKey: Constants.ResponseKeys.PortfolioInfo)  as! [[String:Any]]
            stopNetworkinUseIndicator()
            for i in 0 ..< self.downloadedPortfolios.count{
                CoreDataManager.sharedManager.addPortfolio(dictionary: self.downloadedPortfolios[i])
            }
            
            self.refreshView()
        }
        
    }

}
