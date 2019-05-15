//
//  GoogleRegisterViewController.swift
//  KINDER FOOD FINDER
//
//  Created by 王若豪 on 2019/5/6.
//  Copyright © 2019年 KINDER FOOD FINDER. All rights reserved.
//

import UIKit

class GoogleRegisterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var genderButton: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var selectPickView: UIPickerView!
    
    var pickerData  = [String]()
    var gender = "Male"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectPickView.delegate = self as? UIPickerViewDelegate
        self.selectPickView.dataSource = self as? UIPickerViewDataSource
        pickerData = ["Prefer not to disclose","Under 18","18-29","30-39","40-49","50-59","60+"]
        usernameTextField.text = UserDefaults.standard.string(forKey: "email")
        emailTextField.text = UserDefaults.standard.string(forKey: "email")
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)



        // Do any additional setup after loading the view.
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.ageTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.ageTextField.text = pickerData[row]
    }
    @IBAction func genderButtonClicked(_ sender: Any) {
        switch genderButton.selectedSegmentIndex{
        case 0 :
            gender = "Male"
        case 1 :
            gender = "Female"
        case 2 :
            gender = "secret"
        default:
            break
        }
    }
    
    @IBAction func appTapped(_ sender: Any) {
        selectPickView.isHidden = false
        self.ageTextField.text = "Prefer not to disclose"
        let hideKeyboardView = UIView()
        self.ageTextField.inputView = hideKeyboardView
    }
    @IBAction func appTappedOver(_ sender: Any) {
        selectPickView.isHidden = true
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let username = usernameTextField.text
        let token = UserDefaults.standard.string(forKey: "email")
        let genderOfUser = gender
        let age = ageTextField.text
        let email = UserDefaults.standard.string(forKey: "email")
        if(username?.isEmpty==true||email?.isEmpty==true||age?.isEmpty==true){
            displayMyAlertMessage(userMessage: "All fields are required")
            return;
        }
        if(age?.elementsEqual("Under 18")==false&&age?.elementsEqual("18-29")==false&&age?.elementsEqual("30-39")==false&&age?.elementsEqual("40-49")==false&&age?.elementsEqual("50-59")==false&&age?.elementsEqual("60+")==false&&age?.elementsEqual("Prefer not to disclose")==false){
            displayMyAlertMessage(userMessage: "Age must choose the specific group")
            return;
        }
        //send data to server side
        let myUrl = NSURL(string: "http://ec2-13-239-136-215.ap-southeast-2.compute.amazonaws.com:8000/google_login/")
        let request = NSMutableURLRequest(url: myUrl as! URL);
        request.httpMethod = "POST";
        
        let postString = "username=\(username ?? "")&token=\(token ?? "")&email=\(email ?? "")&gender=\(genderOfUser ?? "")&age=\(age ?? "")";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        print("------------------------------------")
        print(postString)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error=\(error)")
                return
            }
            var err: NSError?
            
            let json = try? JSON(data: data!)
            print(response)
            print("_____")
            print(json ?? "00")
                //self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(username,forKey: "username");
            UserDefaults.standard.set(age,forKey: "age")
            UserDefaults.standard.set(genderOfUser, forKey: "gender")
            UserDefaults.standard.synchronize();
                DispatchQueue.main.async(execute:{
                    let homePage = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = homePage
                })
            
            
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
