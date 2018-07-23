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
    
    @IBOutlet weak var eMailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var checkboxButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountPushHome(_ sender: Any) {
        if let email = eMailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
           registerUserWith(email: eMailField.text!, password: passwordField.text!)
        }else{
            showAlert(alertMessage: "All fields required!")
        }
    }
    
    @IBAction func logInPushHome(_ sender: Any) {
        
        if let email = eMailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty {
            loginUserWith(email: eMailField.text!, password: passwordField.text!)
        }else{
            showAlert(alertMessage: "All fields required!")
        }
       
    }
    
    private func showAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func pushHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerD =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(viewControllerD, animated:
            true)
    }
    
    private func loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        Alamofire
            .request("https://api.infinum.academy/api/users/sessions",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseJSON{ [weak self]
        response in
         SVProgressHUD.dismiss()
                
        switch response.result {
        case .success:
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
            .request("https://api.infinum.academy/api/users",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self]
                (response: DataResponse<User>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success:
                    self?.loginUserWith(email: email, password: password)
                case .failure:
                    self?.showAlert(alertMessage: "Cannot register user with the given data.")
                }
        }
        
        
    }
    
    @IBAction func checkBoxChanged(_ sender: Any) {
        checked = !checked
        
        if checked {
            checkboxButton.setImage(#imageLiteral(resourceName: "ic-checkbox-filled"), for: UIControlState())
        }else {
            checkboxButton.setImage(#imageLiteral(resourceName: "ic-checkbox-empty"), for: UIControlState())
        }
    }
}
