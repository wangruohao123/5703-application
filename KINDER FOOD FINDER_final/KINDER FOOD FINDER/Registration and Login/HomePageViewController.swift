//
//  HomePageViewController.swift
//  UserLoginAndRegisteration
//
//  Created by 王若豪 on 2019/4/26.
//  Copyright © 2019年 com.Ruohao. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HomePageViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = UserDefaults.standard.string(forKey: "username")

    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "username")
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }
    
}
