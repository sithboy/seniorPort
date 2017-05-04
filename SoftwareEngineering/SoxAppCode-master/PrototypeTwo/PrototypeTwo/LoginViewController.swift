//
//  LoginViewController.swift
//  PrototypeOne
//
//  Created by Natalie Peters on 2/1/17.
//  Copyright © 2017 Natalie Peters. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    var userID = Int()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func LoginButtonGo(_ sender: Any) {
        var userData = [String: AnyObject]()
        let username = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        
        let parameters = ["username" : username ,
                          "password" : userPassword].map { "\($0)=\($1 )" }
        
        let userIDString = parameters.joined(separator: "&")
        
        let url:String = "https://ratemyrun.herokuapp.com/login?"+userIDString
        
        let urlRequest = URL(string: url)
        URLSession.shared.dataTask(with: urlRequest!, completionHandler: {
            (data, response, error) in
            if (error != nil) {
                print(error.debugDescription)
            }else{
        do{
            let jArray = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                as! NSDictionary as Dictionary
            userData = jArray as! [String : AnyObject]
            print(userData)
            
            if let dic = jArray as? [String : AnyObject]{
                if let nestedDictionary = dic["body"] as? Int {
                    self.userID = nestedDictionary
                    if (nestedDictionary != 0){
                        UserDefaults.standard.set(self.userID, forKey: "userID")
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        self.displayAlertMessage(userMessage: "Email or Password are incorrect")
                    }
                }
            }
        }catch let error as NSError{
            print(error)
                }
            }
        }).resume()
        print("userID: ")
        print(userID)
        if (self.userID != 0){
            //login successful
            UserDefaults.standard.set(self.userID, forKey: "userID")
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
        }
        else{
            displayAlertMessage(userMessage: "Email or Password are incorrect")
        }
    }
    //display alert
    func displayAlertMessage(userMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        myAlert.addAction(alertAction)
        self.present(myAlert, animated: true, completion:nil)
    }

}
