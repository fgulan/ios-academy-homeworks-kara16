//
//  EmptyStateView.swift
//  TVShows
//
//  Created by Infinum Student Academy on 05/08/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {

    class func instanceFromNib() -> EmptyStateView{
        return UINib(nibName: "View", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmptyStateView
    }
    
}
