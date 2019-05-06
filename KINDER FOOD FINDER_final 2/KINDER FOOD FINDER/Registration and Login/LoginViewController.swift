//
//  LoginViewController.swift
//  UserLoginAndRegisteration
//
//  Created by 王若豪 on 2019/4/9.
//  Copyright © 2019年 com.Ruohao. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: LineButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func SignOutButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
    }
    // Implement these methods only if the GIDSignInUIDelegate is not a subclass of
    // UIViewController.
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        print("sign in presented")
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        print("sign in dismissed")
    }
    @IBAction func loginButtonClicked(_ sender: Any) {
        let username = usernameTextField.text
        let userPassword = passwordTextField.text
        
        if(username!.isEmpty || userPassword!.isEmpty) {
            displayMyAlertMessage(userMessage: "username and password cannot be empty")
            return ;}
        // send user data to server side
        
        let myUrl = NSURL(string: "http://ec2-13-239-136-215.ap-southeast-2.compute.amazonaws.com:8000/users/login")
        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "POST"
        
        let postString = "username=\(username ?? "")&password=\(userPassword ?? "")";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            if error != nil{
                print("error=\(error)")
                return
            }
            let json = try? JSON(data: data!)
            print("___________")
            print(response ?? "")
            print(json ?? "")
            var err: NSError?

            do {
                
                let httpResponse = response as! HTTPURLResponse
                let code = httpResponse.statusCode
                var result: Double = Double(code)
                print(code)
                if(result == 404){
                    DispatchQueue.main.async(execute:{
                        var myAlert = UIAlertController(title: "Alert", message: "username and password are not match ", preferredStyle: UIAlertController.Style.alert);
                        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default,handler:nil)
                        myAlert.addAction(okAction);
                        self.present(myAlert, animated:true, completion:nil);
                        return;
                    })
                }
                if(result==200){
                    let json2 = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    let accessToken = json2!["token"] as? String
                    let saveToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                    //                                UserDefaults.standard.set(true,forKey: "isUserLoggedIn")
                    //                                UserDefaults.standard.synchronize();
                    //                                self.dismiss(animated: true, completion: nil)
                    //store data in local
                    UserDefaults.standard.set(username,forKey: "username");
                    UserDefaults.standard.synchronize();
                    DispatchQueue.main.async(execute:{
                        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                    })
                }
            }
            catch{
                return
            }
            
            
        }
        task.resume()
    }

    
    func displayMyAlertMessage(userMessage:String){
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true,completion: nil)
    }
}
