//
//  clientHelper.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/4/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation

extension client {
    
    func generateRequestOf(type: String!, url: URL!) -> NSMutableURLRequest
    {
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = type
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    func setupBgSession() {
        
        let bgConfiguration = URLSessionConfiguration.background(withIdentifier: "bg.session.id")
        bgConfiguration.allowsCellularAccess = true
        bgConfiguration.timeoutIntervalForRequest = 60
        bgConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        bgSession = URLSession(configuration: bgConfiguration, delegate: self, delegateQueue:OperationQueue())
        bgSession.sessionDescription = "session.bg"
    }
    
    func getDataFromURL(url: URL?, applyOffset:Bool, apiCompletionHandler: @escaping ResutOrError) -> URLSessionDataTask
    {
        let request = generateRequestOf(type: "GET", url: url)

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                apiCompletionHandler(nil, NSError(domain: "ProcessTask", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error!.localizedDescription))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("There was an Error response from the Server")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, applyOffset: applyOffset, completionHandlerForConvertData: apiCompletionHandler)
        }
        task.resume()
        return task
    }
    
    
    //MARK: - Get Method
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping ResutOrError) {
        
        let request = generateRequestOf(type: "GET", url: YahooURLFromParameters(parameters,withPathExtension: method))
        processTask(request as URLRequest, applyOffset:false, completionHandlerForProcessingTask: completionHandlerForGET)
        
    }
    //MARK: - Post Method
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping ResutOrError) {
        let request = generateRequestOf(type: "POST", url: URLFromParameters(parameters, withPathExtension: method))
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        print("[URL CALLED]",request.url!," with [POST BODY]",jsonBody)
        processTask(request as URLRequest, applyOffset:false, completionHandlerForProcessingTask: completionHandlerForPOST)
        
    }
    //MARK: - Put Method
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping ResutOrError) {
        let request = generateRequestOf(type: "PUT", url: URLFromParameters(parameters, withPathExtension: method))
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        processTask(request as URLRequest, applyOffset:false, completionHandlerForProcessingTask: completionHandlerForPOST)
        
    }
    
    private func processTask(_ request: URLRequest, applyOffset:Bool,  completionHandlerForProcessingTask: @escaping ResutOrError)
    {
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForProcessingTask(nil, NSError(domain: "ProcessTask", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error!.localizedDescription))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("There was an Error response from the Server")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, applyOffset: applyOffset, completionHandlerForConvertData: completionHandlerForProcessingTask)
        }
        task.resume()
        
    }
    private func convertDataWithCompletionHandler(_ data: Data, applyOffset:Bool, completionHandlerForConvertData: ResutOrError) {
        
        var parsedResult: AnyObject! = nil
        do {
            var parsedString = String.init(data: data, encoding: String.Encoding.utf8)
            
            if(applyOffset)
            {
                let startIndex = parsedString?.index((parsedString?.startIndex)!, offsetBy: 3)
                parsedString = parsedString?.substring(from: startIndex!)
            }
            
            let jsonData = parsedString?.data(using: String.Encoding.utf8)
            
            parsedResult = try JSONSerialization.jsonObject(with: jsonData!, options: [.allowFragments,.mutableContainers,.mutableLeaves]) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private func URLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        
        components.scheme = Constants.NJIT.APIScheme
        components.host = Constants.NJIT.APIHost
        components.path = Constants.NJIT.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func YahooURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        
        components.scheme = Constants.YAHOO.APIScheme
        components.host = Constants.YAHOO.APIHost
        components.path = Constants.YAHOO.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    private func GoogleURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        
        components.scheme = Constants.GOOGLE.APIScheme
        components.host = Constants.GOOGLE.APIHost
        components.path = Constants.GOOGLE.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func stringFromParam (_ parameters:[String:AnyObject])-> String {
        var outputString = String()
        
        for(key,value) in parameters{
            var value1 = String()
            
            if key == "longitude" || key == "latitude" {
                value1 = String(describing: value)
            } else {
                value1 = "\"\(value)\""
            }
            
            if (outputString.isEmpty){
                
                outputString = "\"\(key)\":\(value1)"
            } else {
                outputString = "\(String(describing: outputString)),\"\(key)\":\(value1)"
            }
        }
        
        return outputString
    }
    
    func getTickersForSearchString(_ searchString: String, completionHandlerForTicker: @escaping (_ result: [YAHOOTickers]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        var parameters = [String:AnyObject]()
            parameters[Constants.ParameterKeys.Query] =  searchString as AnyObject
            parameters[Constants.ParameterKeys.Region] = 1 as AnyObject
            parameters[Constants.ParameterKeys.Language] = "en" as AnyObject
        
        
        let task = getDataFromURL(url: YahooURLFromParameters(parameters,withPathExtension: Constants.Methods.YahooTickerSearch), applyOffset: false) { (response, error) in
            
            if let error = error {
                completionHandlerForTicker(nil, error as NSError)
            } else {
                if let result = response as? NSDictionary {
                  if let results = result.value(forKeyPath: "ResultSet.Result") as? [[String:AnyObject]] {
                    
                    let tickers = YAHOOTickers.tickersFromResults(results)
                    completionHandlerForTicker(tickers, nil)
                    }
                } else {
                    completionHandlerForTicker(nil, NSError(domain: "getTickerForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getTickerForSearchString"]))
                }
            }
        }
        
        return task
    }
    
    func getLastPriceForTicker(_ tickers: [String], completionHandlerForTicker: @escaping (_ result: [GoogleTickers]?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        var parameters = [String:AnyObject]()
        parameters[Constants.ParameterKeys.GoogleQuery] =  googleQParamFromPortfolio(tickers) as AnyObject
        parameters[Constants.ParameterKeys.Client] = "ig" as AnyObject
        
        
         let task = getDataFromURL(url: GoogleURLFromParameters(parameters,withPathExtension: Constants.Methods.GoogleStoclPrice), applyOffset: true) { (response, error) in
            
            if let error = error {
                completionHandlerForTicker(nil, error as NSError)
            } else {
                if let result = response as? [[String:AnyObject]] {
                    
                        let tickers = GoogleTickers.priceFromResults(result)
                        completionHandlerForTicker(tickers, nil)
                    
                } else {
                    completionHandlerForTicker(nil, NSError(domain: "getTickerForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getTickerForSearchString"]))
                }
            }
        }
        
        return task
    }
    
    func googleQParamFromPortfolio(_ tickers:[String])->String{
        var returnString = "NSE:"
        for ticker in tickers {
            returnString += ticker
        }
        return returnString
    }
    
    
}
