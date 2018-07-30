//
//  ShowDetailsViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 27/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit

class ShowDetailsViewCell: UITableViewCell {
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    
    func configureWith(episode: Episode){
        episodeNumberLabel.text = "S" + episode.season + " " + "Ep" + episode.episodeNumber
        episodeTitleLabel.text = episode.title
    }
    
}
