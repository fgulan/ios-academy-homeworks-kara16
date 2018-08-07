//
//  EpisodeCommentTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit

class EpisodeCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    
    func configureWith(comment: Comment, image: UIImage){
        userLabel.text = comment.userEmail
        commentLabel.text = comment.text
        commentImageView.image = image
    }

    

}
