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
    
    //    MARK: - IBOutlets
    
    @IBOutlet private weak var _showTitleLabel: UILabel!
    @IBOutlet private weak var _showImageView: UIImageView!
    
    //    MARK: - Public methods
    
    func configureWith(show: Show){
        _showTitleLabel.text = show.title
        
        let url = URL(string: "https://api.infinum.academy" + show.imageUrl)
        _showImageView.kf.setImage(with: url)
    }
}
