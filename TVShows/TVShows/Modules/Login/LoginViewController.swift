//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 10/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class LoginViewController: UIViewController {
    private var checked = false
    private var user: User?
    private var loginUser: LoginData?
    
    @IBOutlet weak var eMailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var checkboxButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
           let password = UserDefaults.standard.value(forKey: "password") as? String {
            
            eMailField.text = email
            passwordField.text = password
            checkBoxChanged(checkboxButton)
            
            loginUserWith(email: email, password: password)
        }
    }
    
    @IBAction func createAccountPushHome(_ sender: Any) {
        if let email = eMailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
           registerUserWith(email: eMailField.text!, password: passwordField.text!)
        }else{
            if eMailField.text!.isEmpty{
                eMailField.shake()
            }
            
            if passwordField.text!.isEmpty{
                passwordField.shake()
            }
        }
    }
    
    @IBAction func logInPushHome(_ sender: Any) {
        
        if let email = eMailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
            if checkboxButton.isSelected{
                saveUser(email: email, password: password)
            }
            
            loginUserWith(email: eMailField.text!, password: passwordField.text!)
        }else{
            if eMailField.text!.isEmpty{
                eMailField.shake()
            }
            
            if passwordField.text!.isEmpty{
                passwordField.shake()
            }
        }
       
    }
    
    private func saveUser(email: String, password: String){
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(password, forKey: "password")
    }
    
    private func showAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func pushHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerD =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        viewControllerD.loginUser = self.loginUser
        navigationController?.setViewControllers([viewControllerD], animated: true)
    }
    
    private func loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(Constants.URL.baseUrl + "/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:
                DataResponse<LoginData>) in
                
                SVProgressHUD.dismiss()
                
        switch response.result {
        case .success(let loginUser):
                self?.loginUser = loginUser
                self?.pushHome()
        case .failure:
            self?.showAlert(alertMessage: "Invalid username or password.")
        }
        }
    }
    
    private func registerUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(Constants.URL.baseUrl + "/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:
                DataResponse<User>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let user):
                    self?.user = user
                    
                   if let _: Bool = self?.checkboxButton.isSelected {
                        self?.saveUser(email: email, password: password)
                    }
                    
                    self?.loginUserWith(email: email, password: password)
                case .failure:
                    self?.showAlert(alertMessage: "Cannot register user with the given data.")
                }
        }
        
        
    }
    
    @IBAction func checkBoxChanged(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            checkboxButton.setImage(#imageLiteral(resourceName: "ic-checkbox-filled"), for: UIControlState())
        }else {
            checkboxButton.setImage(#imageLiteral(resourceName: "ic-checkbox-empty"), for: UIControlState())
        }
    }
}
