//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 10/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private var checked = false
    
    @IBOutlet weak var checkbox: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountPushHome(_ sender: Any) {
        pushHome()
    }
    @IBAction func logInPushHome(_ sender: Any) {
        pushHome()
    }
    
    private func pushHome() {
        
        // We need to instantiate the Storyboard in which our view controller that we want to go to lives
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        // We need to instantiate the view controller that we want to go to
        let viewControllerD =
            storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        // We need to push that view controller on top of the navigation stack
        navigationController?.pushViewController(viewControllerD, animated:
            true)
    }
    
    @IBAction func checkBoxChanged(_ sender: Any) {
        checked = !checked
        
        if checked {
            checkbox.setImage(#imageLiteral(resourceName: "ic-checkbox-filled"), for: UIControlState())
        }else {
            checkbox.setImage(#imageLiteral(resourceName: "ic-checkbox-empty"), for: UIControlState())
        }
    }
}
