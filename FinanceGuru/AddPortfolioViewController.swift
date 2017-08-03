//
//  AddPortfolioViewController.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/5/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit

class AddPortfolioViewController: UIViewController {

    @IBOutlet weak var portfolioName: UITextField!
    
    @IBAction func AddBtnclicked(_ sender: Any) {
        guard let text = portfolioName.text, !text.isEmpty else {
            showAlertwith(title: "Portfolio Name needs to be mentioned", message: "Try again with a name", vc: self)
            portfolioName.becomeFirstResponder()
            return
        }
        startNetworkinUseIndicator()
        client.sharedInstance.addNewPortfolio(portfolioName: portfolioName.text!) { (responseData, error) in
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
            stopNetworkinUseIndicator()
            let newPortfolios = response.value(forKey: Constants.ResponseKeys.NewPortfolioInfo)  as! [String:Any]
            CoreDataManager.sharedManager.addPortfolio(dictionary: newPortfolios)
            performOnMainthread {
                _ = self.navigationController?.popViewController(animated: true)
            }
            

        }
        
        
    }
}
