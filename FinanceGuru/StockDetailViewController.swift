//
//  StockDetailViewController.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/8/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import CoreData

class StockDetailViewController: UIViewController {

    var action:stockAction?
    var stock:YAHOOTickers?
    var selectedPortfolio:Portfolio?
    var selectedStock:Stock?
    var lastPrice:Double?
    var searchTask: URLSessionDataTask?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateofAction: UITextField!
    @IBOutlet weak var unitsTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var selectedStockLbl: UILabel!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if action == stockAction.buy{
            buyButton.isSelected = true
        } else if action == stockAction.sell {
            sellButton.isSelected = true
        }
        title = "Stock Transaction"
        selectedStockLbl.text = stock?.companyname
        startNetworkinUseIndicator()
        searchTask = client.sharedInstance.getLastPriceForTicker([(stock?.ticker)!]) { (stockLastPrice, error) in
            self.searchTask = nil
            stopNetworkinUseIndicator()
            guard error == nil else{
                
                //Removed the message as this functianlity was to facilitate the user with the latest price for convinience and this should only be popping up when response from google service 
//                showAlertwith(title: "Google finance error", message: "Something went wrong fetching the last price", vc: self)
                return
            }
            
            performOnMainthread {
                self.priceTextField.text = stockLastPrice?[0].lastPrice
                self.lastPrice = Double((stockLastPrice?[0].lastPrice)!)
            }
            
        }
        
        
    }

    @IBAction func actionClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            buyButton.isSelected = true
            sellButton.isSelected = false
            action = stockAction.buy
        } else if sender.tag == 2 {
            buyButton.isSelected = false
            sellButton.isSelected = true
            action = stockAction.sell
        }
    }

    @IBAction func saveClicked(_ sender: UIButton) {
        
        
        
        guard unitsTextField.text != "0" else {
            showAlertwith(title: "Units can not be 0", message: "", vc: self)
            return
        }
        guard priceTextField.text != "0",priceTextField.text != "" else {
            showAlertwith(title: "Price can not be 0", message: "", vc: self)
            return
        }
        self.lastPrice = Double(priceTextField.text!)
        guard dateofAction.text != "" else {
            showAlertwith(title: "Select a date", message: "", vc: self)
            dateofAction.becomeFirstResponder()
            return
        }
        CoreDataManager.sharedManager.currentPortfolio = selectedPortfolio
            if(selectedStock == nil)
            {
                var dictionary=[String:AnyObject]()
                dictionary["ticker"] = stock?.ticker as AnyObject
                dictionary["stockname"] = stock?.companyname as AnyObject
                dictionary["costbasisusd"] = String(Double(priceTextField.text!)! * Double(unitsTextField.text!)!) as AnyObject
                dictionary["costbasis"] = String(Double(priceTextField.text!)! * Double(unitsTextField.text!)!) as AnyObject
                dictionary["last_price"] = String(describing: lastPrice) as AnyObject
                dictionary["sid"] = "0" as AnyObject
                dictionary["gain"] = "0" as AnyObject
                dictionary["gain_percent"] = "0" as AnyObject
                dictionary["qty"] = unitsTextField.text as AnyObject
                
                CoreDataManager.sharedManager.addStock(dictionary: dictionary)
                self.dbStack.save()
                
            } else {
                CoreDataManager.sharedManager.updateStock(stock: selectedStock!, price: lastPrice!, qty: Int(unitsTextField.text!)!, action: action!)
            }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDatePickerPressed))
        toolBar.setItems([cancelButton,space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        dateofAction.inputAccessoryView = toolBar
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @objc func doneDatePickerPressed() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        if dateofAction.text == "" {
            dateofAction.text = dateFormatter1.string(from: datePicker.date)
        }
        dateofAction.resignFirstResponder()
    }
    @objc func cancelClick(){
        dateofAction.resignFirstResponder()
    }
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateofAction.text = dateFormatter.string(from: sender.date)
    }
   
}
