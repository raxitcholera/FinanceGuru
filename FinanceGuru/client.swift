//
//  client.swift
//  VirtualTourist
//
//  Created by Raxit Cholera on 6/26/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth

class client: NSObject, URLSessionDelegate{
    
    // MARK: Properties
    
    static let sharedInstance = client()
    // shared session
    var session = URLSession.shared
    var dataTask = URLSession()
    var bgSession = URLSession()
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
        setupBgSession()
    }
    //MARK: Config session
        
    func loginWithCredentials(userName: String, password: String, apiCompletionHandler: @escaping ResutOrError)
    {
        let  urlparameters = [String:AnyObject]()
        var  parameters = [String:AnyObject]()
        parameters["pmo_username"] = userName as AnyObject
        parameters["pmo_password"] = password as AnyObject
        
        let jsonBody = "{ \(stringFromParam(parameters)) }"
        taskForPOSTMethod(Constants.Methods.AuthorizationURL, parameters: urlparameters, jsonBody: jsonBody, completionHandlerForPOST: apiCompletionHandler)
        
    }
    
    func registerWithFirebaseCredentials(currentUser:User, apiCompletionHandler: @escaping ResutOrError)
    {
        let  urlparameters = [String:AnyObject]()
        var  parameters = [String:AnyObject]()
        parameters["pmo_email"] = currentUser.email as AnyObject
        parameters["pmo_password"] = currentUser.uid as AnyObject
        
        let fullName = currentUser.displayName
        let fullNameArr = fullName?.characters.split{$0 == " "}.map(String.init)
        let firstName: String = fullNameArr![0]
        let lastName: String? = (fullNameArr?.count)! > 1 ? fullNameArr?[1] : nil
        
        parameters["pmo_fname"] = firstName as AnyObject
        parameters["pmo_lname"] = lastName as AnyObject
        
        let jsonBody = "{ \(stringFromParam(parameters)) }"
        taskForPOSTMethod(Constants.Methods.CreateUser, parameters: urlparameters, jsonBody: jsonBody, completionHandlerForPOST: apiCompletionHandler)
        
    }
    func updatePortfolioInformation(apiCompletionHandler: @escaping ResutOrError)
    {
        let  urlparameters = [String:AnyObject]()
        var  parameters = [String:AnyObject]()
        let currentUserID = appDelegate.loggedinUser?.userID
        parameters["authenticated"] = true as AnyObject
        parameters["id"] = currentUserID as AnyObject
        
        let jsonBody = "{ \(stringFromParam(parameters)) }"
        taskForPOSTMethod(Constants.Methods.UserPortfolioList, parameters: urlparameters, jsonBody: jsonBody, completionHandlerForPOST: apiCompletionHandler)
        
    }
    
    func addNewPortfolio(portfolioName:String,apiCompletionHandler: @escaping ResutOrError)
    {
        let  urlparameters = [String:AnyObject]()
        var  parameters = [String:AnyObject]()
        let currentUserID = appDelegate.loggedinUser?.userID
        parameters["authenticated"] = true as AnyObject
        parameters["userId"] = currentUserID as AnyObject
        parameters["portfolio_name"] = portfolioName as AnyObject
        
        let jsonBody = "{ \(stringFromParam(parameters)) }"
        taskForPOSTMethod(Constants.Methods.UserPortfolioAdd, parameters: urlparameters, jsonBody: jsonBody, completionHandlerForPOST: apiCompletionHandler)
    }
    
    func updateStockInformation(apiCompletionHandler: @escaping ResutOrError)
    {
        let  urlparameters = [String:AnyObject]()
        var  parameters = [String:AnyObject]()
        parameters["authenticated"] = true as AnyObject
        parameters["pid"] = CoreDataManager.sharedManager.currentPortfolio?.pid as AnyObject
        
        let jsonBody = "{ \(stringFromParam(parameters)) }"
        taskForPOSTMethod(Constants.Methods.UserStockList, parameters: urlparameters, jsonBody: jsonBody, completionHandlerForPOST: apiCompletionHandler)
    }
    
}
