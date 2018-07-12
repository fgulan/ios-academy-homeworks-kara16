//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 10/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private var tapCount:Int = 0
    @IBOutlet weak var IBOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText(text: "Number of clicks: " + String(tapCount))
    }

    @IBAction func IBAction(_ sender: Any) {
        tapCount += 1
        setLabelText(text: "Number of clicks: " + String(tapCount))
    }
    
    private func setLabelText(text: String) {
        IBOutlet.text = text
    }
}
