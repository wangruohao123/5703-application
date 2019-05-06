//
//  WelcomeViewController.swift
//  KINDER FOOD FINDER
//
//  Created by 王若豪 on 2019/5/6.
//  Copyright © 2019年 KINDER FOOD FINDER. All rights reserved.
//

import UIKit
import GoogleSignIn

class WelcomeViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var googleSignInButton: LineButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func googleSignInTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
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
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "Signed in user:\n\(fullName)"])
        // [END_EXCLUDE]
                    UserDefaults.standard.set(idToken,forKey: "idToken");
                    UserDefaults.standard.set(email,forKey: "email");
                    UserDefaults.standard.synchronize();
                    let myUrl = NSURL(string: "http://ec2-13-239-136-215.ap-southeast-2.compute.amazonaws.com:8000/google_auth/")
                    let request = NSMutableURLRequest(url: myUrl! as URL)
                    request.httpMethod = "POST"
        
                    let postString = "username=\(email ?? "")";
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
                            if(result == 400){
                                UserDefaults.standard.set(email,forKey: "username");
                                UserDefaults.standard.synchronize();
                                DispatchQueue.main.async(execute:{
                                    let homePage = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
                                    let appDelegate = UIApplication.shared.delegate
                                    appDelegate?.window??.rootViewController = homePage
                                })
                                
                            }
                            if(result==201){
                                DispatchQueue.main.async(execute:{
                                    let homePage = self.storyboard?.instantiateViewController(withIdentifier: "GoogleRegisterViewController") as! GoogleRegisterViewController
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
}
