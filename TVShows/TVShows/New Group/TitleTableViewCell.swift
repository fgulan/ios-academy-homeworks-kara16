//
//  TitleTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var showTitleLabel: UILabel!
    
    func configureWith(show: Show){
        showTitleLabel.text = show.title
    }
}
