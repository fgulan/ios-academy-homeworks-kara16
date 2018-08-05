//
//  ListCollectionViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 05/08/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit
import Kingfisher

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    
    func configureWith(show: Show){
        showTitleLabel.text = show.title
        
        let url = URL(string: "https://api.infinum.academy" + show.imageUrl)
        showImageView.kf.setImage(with: url)
    }
}
