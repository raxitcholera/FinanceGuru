//
//  LoginViewController.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/3/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import CoreData

class LoginViewController: UIViewController ,FBSDKLoginButtonDelegate, GIDSignInUIDelegate,GIDSignInDelegate {
    
    @IBOutlet weak var FbLoginButton: FBSDKLoginButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var userPredicate: NSPredicate?
    
    var existingUsers = [PortfolioUser]()
    
    enum sourcesOfLogin:String {
        case website,firebase
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FbLoginButton.delegate = self
        FbLoginButton.readPermissions = ["email","public_profile"]
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        checkIfAlreadyLoggedIn()
    }
    
    //MARK:- Self Signin Protocols
    @IBAction func LoginButtinClicked(_ sender: Any) {
        guard let UserName = userName.text, let Password = password.text else {
            showAlertwith(title: "Both Fields are Needed to Login", message: "Please Try again", vc: self)
            return
        }
        
        processLogin(UserName, password: Password, source: sourcesOfLogin.website)
    
    }
    
    //MARK:- Facebook Signin Protocols
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of FB")
        
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            showAlertwith(title: "Sigin with FaceBook failed", message: String(describing: error.localizedDescription), vc: self)
            return
        }
        
        guard  result?.isCancelled == false else {
            showAlertwith(title: "Sigin with FaceBook cancelled", message: "The user canceled the Sign-in flow", vc: self)
            return
        }
        
        
        
        print("Successfully logged in")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, error) in
            print(result as Any!)
            let credentials = FacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current()?.tokenString)!)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if error != nil {
                    showAlertwith(title: "Error From FireBase", message: String(describing: error!.localizedDescription), vc: self)
                    return
                }
                print("User :- ",user?.uid ?? "")
                self.processLogin((user?.email)!, password: (user?.uid)!, source: sourcesOfLogin.firebase)
            })
            
        }
    }
    
    //MARK:- Google Signin Protocols
    func sign(_ signIn:GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if let error = error {
            showAlertwith(title: "Sigin with google failed", message: String(describing: error.localizedDescription), vc: self)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Error Logging into firebase with google.",error!.localizedDescription )
                showAlertwith(title: "Error From FireBase", message: String(describing: error!.localizedDescription), vc: self)
                return
            }
            print("Firebase user id ",user?.uid ?? "")
            self.processLogin((user?.email)!, password: (user?.uid)!, source: sourcesOfLogin.firebase)
        }
    }
    
    //MARK:- If Google or FB already logged in
    func checkIfAlreadyLoggedIn() {
        if Auth.auth().currentUser != nil {
            print("Alreday Logged in Fetch UserData from api and move ahead using ",Auth.auth().currentUser?.uid as Any)
            processLogin((Auth.auth().currentUser?.email)!, password: (Auth.auth().currentUser?.uid)!, source: sourcesOfLogin.firebase)
        }
        
    }
    
    func processLogin(_ userName:String, password:String, source:sourcesOfLogin)
    {
        
        
        startNetworkinUseIndicator()
        client.sharedInstance.loginWithCredentials(userName: userName, password: password) { (response, error) in
            guard (error == nil) else {
                showAlertwith(title: "Connection issue with NJIT server", message: "Login Failed:- \(String(describing: error!.localizedDescription))", vc: self)
                return
            }
            stopNetworkinUseIndicator()
            if let result = response as? NSDictionary {
                let status = result.value(forKeyPath: Constants.ResponseKeys.Status) as? String
                if status == Constants.ResponseKeys.Fail && source == sourcesOfLogin.firebase {
                    if let currentUser = Auth.auth().currentUser{
                        startNetworkinUseIndicator()
                        client.sharedInstance.registerWithFirebaseCredentials(currentUser: currentUser, apiCompletionHandler: { (response, error) in
                            guard (error == nil) else {
                                showAlertwith(title: "Creating new Usre after Firebase auth Failed", message: "Firebase Registration Failed:- \(String(describing: error!.localizedDescription))", vc: self)
                                return
                            }
                            stopNetworkinUseIndicator()
                            if let result = response as? NSDictionary {
                                let status = result.value(forKeyPath: Constants.ResponseKeys.Status) as? String
                                if status == Constants.ResponseKeys.Fail {
                                    showAlertwith(title: "Creating new User after Firebase auth Successeed", message: "Firebase Registration Failed:- \(String(describing: result.value(forKeyPath: Constants.ResponseKeys.Message)))", vc: self)
                                    return
                                }else if status == Constants.ResponseKeys.Success {
                                    var sessionInfo = result.value(forKeyPath: Constants.ResponseKeys.SessionInfo) as! [String:Any]
                                    sessionInfo["pmo_username"] = userName
                                    if(!self.assignUserData(userName: userName)){
//                                    sessionInfo["pmo_password"] = password
                                    self.appDelegate.loggedinUser = CoreDataManager.sharedManager.addUser(dictionary: sessionInfo)
                                    self.redirectToPortfolio()
                                    }
                                    
                                }
                                
                            }
                        })
                        
                    }
                } else if status == Constants.ResponseKeys.Success {
                    if(!self.assignUserData(userName: userName)) {
                    var sessionInfo = result.value(forKeyPath: Constants.ResponseKeys.SessionInfo) as! [String:Any]
                    sessionInfo["pmo_username"] = userName
                    sessionInfo["pmo_password"] = password
                    self.appDelegate.loggedinUser = CoreDataManager.sharedManager.addUser(dictionary: sessionInfo)
                    self.redirectToPortfolio()
                    }
                    
                } else {
                    showAlertwith(title: "User Does not exist in database", message: "Try with a different user", vc: self)
                    return
                }
            } else {
                showAlertwith(title: "Server Unavailable", message: " Pleaes try again", vc: self)
                return
            }
            
        }
    }
    
    
    //MARK:- After login redirect to Portolio list view
    func redirectToPortfolio(){
        performOnMainthread {
            let mainTabView = self.storyboard?.instantiateViewController(withIdentifier: "portfolioViewController") as! PortfolioTableViewController
            self.navigationController?.pushViewController(mainTabView, animated: true)
        }
    }
    
    func assignUserData(userName:String)->Bool {
        do {
            
            let request:NSFetchRequest<PortfolioUser> = PortfolioUser.fetchRequest()
            
            request.predicate = NSPredicate(format: "username == %@", userName)
            existingUsers = try dbStack.context.fetch(request)
            
            if(existingUsers.count > 0)
            {
                appDelegate.loggedinUser = existingUsers[0]
                redirectToPortfolio()
                return true
            } else {
                return false
            }
        }
            
        catch {
            
            print("Error while fetching entity 'PortfolioUser': \(error.localizedDescription)")
            return false
        }
    }
    
    
}

