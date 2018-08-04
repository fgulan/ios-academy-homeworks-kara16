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

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    
    var episode: Episode?
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabels()
        setImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setLabels(){
        episodeTitleLabel.text = episode?.title
        episodeNumberLabel.text = "S" + (episode?.season)! + " Ep" + (episode?.episodeNumber)!
        episodeDescriptionLabel.text = episode?.description
    }
    
    private func setImage(){
        if episode!.imageUrl != ""{
            let url = URL(string: Constants.URL.baseDomainUrl + episode!.imageUrl)
            episodeImageView.kf.setImage(with: url)
        }else{
            episodeImageView.image = #imageLiteral(resourceName: "no_image_available")
        }
    }

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
}
