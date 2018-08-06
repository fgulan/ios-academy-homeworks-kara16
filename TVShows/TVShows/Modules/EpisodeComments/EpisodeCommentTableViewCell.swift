//
//  EpisodeCommentTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit

class EpisodeCommentTableViewCell: UITableViewCell {

    //    MARK: - IBOutlets
    
    @IBOutlet private weak var _userLabel: UILabel!
    @IBOutlet private weak var _commentLabel: UILabel!
    @IBOutlet private weak var _commentImageView: UIImageView!
    
    //    MARK: - Public methods
    
    func configureWith(comment: Comment, image: UIImage){
        _userLabel.text = comment.userEmail
        _commentLabel.text = comment.text
        _commentImageView.image = image
    }

    

}
