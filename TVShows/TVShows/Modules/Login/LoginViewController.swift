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
    
    //    MARK: - Private properties
    
    private var _checked = false
    private var _user: User?
    private var _loginUser: LoginData?
    
    //    MARK: - IBOutlets
    
    @IBOutlet private weak var _eMailField: UITextField!
    @IBOutlet private weak var _passwordField: UITextField!
    @IBOutlet private weak var _checkboxButton: UIButton!
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
           let password = UserDefaults.standard.value(forKey: "password") as? String {
            
            _eMailField.text = email
            _passwordField.text = password
            checkBoxChanged(_checkboxButton)
            
            loginUserWith(email: email, password: password)
        }
    }
    
    //    MARK: - IBActions
    
    @IBAction func createAccountPushHome(_ sender: Any) {
        if let email = _eMailField.text, let password = _passwordField.text, !email.isEmpty, !password.isEmpty {
           registerUserWith(email: _eMailField.text!, password: _passwordField.text!)
        }else{
            if _eMailField.text!.isEmpty{
                _eMailField.shake()
            }
            
            if _passwordField.text!.isEmpty{
                _passwordField.shake()
            }
        }
    }
    
    @IBAction func logInPushHome(_ sender: Any) {
        
        if let email = _eMailField.text, let password = _passwordField.text, !email.isEmpty, !password.isEmpty {
            if _checkboxButton.isSelected{
                saveUser(email: email, password: password)
            }
            
            loginUserWith(email: _eMailField.text!, password: _passwordField.text!)
        }else{
            if _eMailField.text!.isEmpty{
                _eMailField.shake()
            }
            
            if _passwordField.text!.isEmpty{
                _passwordField.shake()
            }
        }
    }
    
    @IBAction func checkBoxChanged(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            _checkboxButton.setImage(#imageLiteral(resourceName: "ic-checkbox-filled"), for: UIControlState())
        }else {
            _checkboxButton.setImage(#imageLiteral(resourceName: "ic-checkbox-empty"), for: UIControlState())
        }
    }
    
    //    MARK: - Private methods -
    
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
        viewControllerD.loginUser = self._loginUser
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
                self?._loginUser = loginUser
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
                    self?._user = user
                    
                   if let _: Bool = self?._checkboxButton.isSelected {
                        self?.saveUser(email: email, password: password)
                    }
                    
                    self?.loginUserWith(email: email, password: password)
                case .failure:
                    self?.showAlert(alertMessage: "Cannot register user with the given data.")
                }
        }
    }
}
