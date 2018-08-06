//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class EpisodeDetailsViewController: UIViewController {
    //    MARK: - Public properties
    
    var episode: Episode?
    var token: String?
    
    //    MARK: - IBOutlets
    
    @IBOutlet private weak var _episodeImageView: UIImageView!
    @IBOutlet private weak var _episodeTitleLabel: UILabel!
    @IBOutlet private weak var _episodeNumberLabel: UILabel!
    @IBOutlet private weak var _episodeDescriptionLabel: UILabel!
    
    //    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabels()
        setImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //    MARK: - IBActions
    @IBAction func returnToShowDetails(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func jumpToComments(_ sender: Any) {
        let storyboard = UIStoryboard(name: "EpisodeComments", bundle: nil)
        let episodeCommentsViewController = storyboard.instantiateViewController(
            withIdentifier: "EpisodeCommentsViewController"
            ) as! EpisodeCommentsViewController
        
        episodeCommentsViewController.token = self.token
        episodeCommentsViewController.episodeId = episode?.id
        
        let navigationController = UINavigationController(rootViewController:
            episodeCommentsViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    //    MARK: - Private methods
    
    private func setLabels(){
        _episodeTitleLabel.text = episode?.title
        _episodeNumberLabel.text = "S" + (episode?.season)! + " Ep" + (episode?.episodeNumber)!
        _episodeDescriptionLabel.text = episode?.description
    }
    
    private func setImage(){
        if episode!.imageUrl != ""{
            let url = URL(string: Constants.URL.baseDomainUrl + episode!.imageUrl)
            _episodeImageView.kf.setImage(with: url)
        }else{
            _episodeImageView.image = #imageLiteral(resourceName: "no_image_available")
        }
    }

    
}
