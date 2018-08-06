//
//  ShowDetailsViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 27/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit

class ShowDetailsViewCell: UITableViewCell {
    //    MARK: - Private properties
    
    @IBOutlet private weak var _episodeTitleLabel: UILabel!
    @IBOutlet private weak var _episodeNumberLabel: UILabel!
    
    //    MARK: - Public methods
    
    func configureWith(episode: Episode){
        _episodeNumberLabel.text = "S" + episode.season + " " + "Ep" + episode.episodeNumber
        _episodeTitleLabel.text = episode.title
    }
    
}
