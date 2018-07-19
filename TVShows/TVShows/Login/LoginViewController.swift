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
    
    @IBAction func checkBoxChanged(_ sender: Any) {
        checked = !checked
        
        if checked {
            checkbox.setImage(#imageLiteral(resourceName: "ic-checkbox-filled"), for: UIControlState())
        }else {
            checkbox.setImage(#imageLiteral(resourceName: "ic-checkbox-empty"), for: UIControlState())
        }
    }
}
