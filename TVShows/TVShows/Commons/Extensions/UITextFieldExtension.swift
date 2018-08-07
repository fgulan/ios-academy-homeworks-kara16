//
//  UITextFieldExtension.swift
//  TVShows
//
//  Created by Infinum Student Academy on 31/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.duration = 0.05
        animation.repeatCount = 7
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: center.x - 4.0, y: center.y)
        animation.toValue = CGPoint(x: center.x + 4.0, y: center.y)
        
        layer.add(animation, forKey: "position")
    }
    
}
