//
//  RegisterViewController.swift
//  UserLoginAndRegisteration
//
//  Created by 王若豪 on 2019/4/8.
//  Copyright © 2019年 com.Ruohao. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{



    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var genderButton: UISegmentedControl!
    @IBOutlet weak var selectPickView: UIPickerView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    var pickerData  = [String]()
    var gender = "Male"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectPickView.delegate = self as? UIPickerViewDelegate
        self.selectPickView.dataSource = self as? UIPickerViewDataSource
      pickerData = ["Prefer not to disclose","Under 18","18-29","30-39","40-49","50-59","60+"]
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)


        // Do any additional setup after loading the view.
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.usernameTextField.resignFirstResponder()//username放弃第一响应者
            self.passwordTextField.resignFirstResponder()//password放弃第一响应者
            self.ageTextField.resignFirstResponder()
            self.emailTextField.resignFirstResponder()
            self.repeatPasswordTextField.resignFirstResponder()
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
    @IBAction func appTapped(_ sender: Any) {
        selectPickView.isHidden = false
        self.ageTextField.text = "Prefer not to disclose"
        let hideKeyboardView = UIView()
        self.ageTextField.inputView = hideKeyboardView
    }
    
    @IBAction func appTappedOver(_ sender: Any) {
              selectPickView.isHidden = true
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
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    @IBAction func registerButtonClicked(_ sender: Any) {
        let username = usernameTextField.text;
        let userPassword = passwordTextField.text;
        let userRepeatPassword = repeatPasswordTextField.text;
        let genderOfUser = gender;
        let email = emailTextField.text;
        let age = ageTextField.text;
        
        
        //check for empty fields
        if(username?.isEmpty==true||userPassword?.isEmpty==true||userRepeatPassword?.isEmpty==true||email?.isEmpty==true||age?.isEmpty==true){
            displayMyAlertMessage(userMessage: "All fields are required")
            return;
        }
        if(isValidEmail(testStr: email!)==false){
            displayMyAlertMessage(userMessage: "Email format is not correct")
            return;
        }
        if(age?.elementsEqual("Under 18")==false&&age?.elementsEqual("18-29")==false&&age?.elementsEqual("30-39")==false&&age?.elementsEqual("40-49")==false&&age?.elementsEqual("50-59")==false&&age?.elementsEqual("60+")==false&&age?.elementsEqual("Prefer not to disclose")==false){
            displayMyAlertMessage(userMessage: "Age must choose the specific group")
            return;
        }
        //check password
        if(userPassword != userRepeatPassword){
            displayMyAlertMessage(userMessage: "Password do not match")
            return;
        }
        //send data to server side
        let myUrl = NSURL(string: "http://ec2-13-239-136-215.ap-southeast-2.compute.amazonaws.com:8000/users/register")
        let request = NSMutableURLRequest(url: myUrl as! URL);
        request.httpMethod = "POST";
      
        let postString = "username=\(username ?? "")&password=\(userPassword ?? "")&email=\(email ?? "")&gender=\(genderOfUser ?? "")&age=\(age ?? "")";
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
            if(json?["MSG"] == "Sorry, account created failed, we are fixing the amazing server made by Eddie please wait"){
                DispatchQueue.main.async(execute:{
                    var myAlert = UIAlertController(title: "Alert", message: "Account has existed, please try another one ", preferredStyle: UIAlertController.Style.alert);
                    let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default,handler:nil)
                    myAlert.addAction(okAction);
                    self.present(myAlert, animated:true, completion:nil);
                    return;
                })
            }else{
                //print(postString)
                self.dismiss(animated: true, completion: nil)
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
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
}
