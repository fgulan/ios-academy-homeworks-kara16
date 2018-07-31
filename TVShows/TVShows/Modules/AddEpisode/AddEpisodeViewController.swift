//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 27/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

protocol ShouldReload: class {
    func shouldReloadEpisodes(episode: Episode)
}

class AddEpisodeViewController: UIViewController {
    var delegate: ShouldReload?
    
    var showId: String?
    var token: String?

    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add episode"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectAddShow))
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: false)
    }
    
    @objc func didSelectAddShow() {
        
        let token: String = self.token!
        let headers = ["Authorization": token]
        
        let parameters: [String: String] = [
            "showId": showId!,
            "mediaId": "",
            "title": episodeTitleTextField.text!,
            "description": episodeDescriptionTextField.text!,
            "episodeNumber": episodeNumberTextField.text!,
            "season": seasonNumberTextField.text!
        ]
        
        SVProgressHUD.show()
        
        Alamofire
            .request(Constants.URL.baseUrl + "/episodes",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:
             DataResponse<Episode>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let episode):
                    self?.delegate?.shouldReloadEpisodes(episode: episode)
                  self?.dismiss(animated: true)
                case .failure(let error):
                    print(error)
                    self?.showAlert(alertMessage: "Adding episode failed")
                }
        }
        
    }
    
    private func showAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
