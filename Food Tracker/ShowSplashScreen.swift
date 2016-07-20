//
//  ShowSplashScreen.swift
//  Fabric
//
//  Created by Parth Pancholi on 2016-07-13.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//
import Foundation
import UIKit

class ShowSplashScreen: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var warning: UILabel!
    
    func updateWarning(msg:String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.warning.text = msg
            print(msg)
        })
    }
    func shouldTransition() -> Bool {
        
        var actionB = false// || true
        var visited = false// || true
        if (userID.text! != "" && password.text! != "")
        {
            
            
            let url = "http://lit-plains-99831.herokuapp.com/confirm_user?name=" + userID.text! + "&password=" + password.text!
            
            let requestURL: NSURL = NSURL(string: url)!
            
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                if error != nil {
                    //                    create a label for invalid password or userid
                    print("error=\(error)")
                    return
                }
                if response == nil {
                    print("empty response")
                }
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    //                    print(data.dynamicType)
                    //                let results = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    
                    do {
                        let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.MutableLeaves) as? NSDictionary
                        
                        if let parseJSON = myJSON {
                            let status = parseJSON["status"] as? String
                            if(status! == "OK")
                            {
                                self.updateWarning("SUCCESS")
                                actionB = true
                            }
                            else
                            {
                                self.updateWarning("UserID or Password is Incorrect")
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                    visited = true //                    print(results)
                }
            }
            
            task.resume()
            
        }
        else if (password.text! == "" && userID.text! == "")
        {
            self.updateWarning("USERID AND PASSWORD IS MISSING")
            visited = true
        }
        else if (password.text! == "")
        {
            self.updateWarning("PASSWORD IS MISSING")
            visited = true
        }
        else
        {
            self.updateWarning("USERID IS MISSING")
            visited = true
        }
        while(!visited)
        {
            
        }
        return actionB
    }
    func shouldRegister() -> Bool {
        
        var actionB = false
        var visited = false
        if (userID.text! != "" && password.text! != "")
        {
            let url = "http://lit-plains-99831.herokuapp.com/get_task?name=" + userID.text!
            let requestURL: NSURL = NSURL(string: url)!
            
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest)
            {
                (data, response, error) -> Void in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                if response == nil {
                    print("empty response")
                }
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.MutableLeaves) as? NSDictionary
                        
                        if let parseJSON = myJSON {
                            let status = parseJSON["status"] as? String
                            if(status! == "Success!")
                            {
                                self.updateWarning("USERID ALREADY EXISTS")
                                
                            }
                            else
                            {
                                self.updateWarning("Registered")
                                let myUrl = NSURL(string: "http://lit-plains-99831.herokuapp.com/new_user?")
                                let request = NSMutableURLRequest(URL: myUrl!)
                                request.HTTPMethod = "POST"
                                let postString = "name=" + self.userID.text! + "&password=" + self.password.text!
                                
                                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                                
                                let innerTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
                                {
                                    (data, response, error) -> Void in
                                    
                                    if error != nil {
                                        print("error=\(error)")
                                        return
                                    }
                                    if response == nil {
                                        print("empty response")
                                    }
                                }
                                
                                let httpResponse = response as! NSHTTPURLResponse
                                let statusCode = httpResponse.statusCode
                                
                                if (statusCode == 200) {
                                    do {
                                        let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.MutableLeaves) as? NSDictionary
                                
                                        if let parseJSON = myJSON {
                                            let status = parseJSON["name"] as? String
                                            print(status!)
                                            actionB = true
                                        }
                                    }
                                    catch {
                                        print(error)
                                    }
                                    visited = true
                                }
                                innerTask.resume()
                                
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                    visited = true
                }
            }
            
            task.resume()
            
        }
        else if (password.text! == "" && userID.text! == "")
        {
            self.updateWarning("USERID AND PASSWORD IS MISSING")
            visited = true
        }
        else if (password.text! == "")
        {
            self.updateWarning("PASSWORD IS MISSING")
            visited = true
        }
        else
        {
            self.updateWarning("USERID IS MISSING")
            visited = true
        }
        while(!visited)
        {
            
        }
        return actionB
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            if ident == "showSplashScreen" {
                // DO LOGIN IN AUTHENTICATION, IF SUCCESSFUL RETURN TRUE HERE, ELSE RETURN FALSE
                var res = false
                res = shouldTransition()
                return res
            }
            else if ident == "registered"
            {
                var res = false
                res = shouldRegister()
                return res
            }
        }
        return true
    }
    
    
    
    override func viewDidLoad()
    {
        print("ready")
        super.viewDidLoad()
//        ------------------------
        //        ------------------------
    }
    func showNavController(){
        sleep(2);
        performSegueWithIdentifier("showSplashScreen", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

}