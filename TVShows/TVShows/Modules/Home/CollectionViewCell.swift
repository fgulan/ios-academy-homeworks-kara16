//
//  CollectionViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 04/08/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureWith(show: Show){
        let url = URL(string: "https://api.infinum.academy" + show.imageUrl)
        imageView.kf.setImage(with: url)
    }
}
