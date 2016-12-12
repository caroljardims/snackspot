//
//  LoginViewController.swift
//  SnackSpot
//
//  Created by Caroline Siqueira on 07/12/16.
//  Copyright © 2016 Caroline Siqueira. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var data:[String:AnyObject] = [:]
    var flag = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        // usar constraints quando der
        loginButton.frame = CGRect(x:50 , y:210, width: view.frame.width-100, height: 50)
        loginButton.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let infosDefault = UserDefaults.standard
        
        if infosDefault.value(forKey: "userLogged") != nil {
            print("HERE WE GO!")
            performSegue(withIdentifier: "logged", sender: self)
        }
    }

    func fetchProfile(){
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email,picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(error)")
            }
            
            self.data = result as! [String : AnyObject]
//            print(" DATA " + String(describing: self.data))
            self.callSegue()
        })
        
    }
    
    func callSegue(){
        performSegue(withIdentifier: "logged", sender: self)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged Out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        print("YEY LOGGED TO THE FACEBOOK SOCIAL NETWORK")
        fetchProfile()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logged" {
            let sendId = segue.destination as! ViewController
            sendId.userFBInfo = self.data
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
