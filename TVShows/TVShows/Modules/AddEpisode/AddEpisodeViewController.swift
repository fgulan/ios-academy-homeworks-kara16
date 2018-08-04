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
import Photos

protocol AddNewEpisodeDelegate: class {
    func shouldReloadEpisodes(episode: Episode)
}

class AddEpisodeViewController: UIViewController {
    weak var delegate: AddNewEpisodeDelegate?
    
    private var imagePicker = UIImagePickerController()
    private var mediaId = ""
    private var image: UIImage?
    
    var showId: String?
    var token: String?

    @IBOutlet weak var episodeTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var episodeNumberTextField: UITextField!
    @IBOutlet weak var episodeDescriptionTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
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
        if image != nil {
            uploadImageOnAPI(token: token!)
        }else{
            addEpisode()
        }
        
    }
    
    @IBAction func addEpisodeImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func showAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Alert", message:
            alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func uploadImageOnAPI(token: String) {
        let headers = ["Authorization": token]
        
        let someUIImage = image!
        let imageByteData = UIImagePNGRepresentation(someUIImage)!
         SVProgressHUD.show()
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: Constants.URL.baseUrl + "/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                
                SVProgressHUD.dismiss()
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        
    }
    
    private func processUploadRequest(_ uploadRequest: UploadRequest) {
        SVProgressHUD.show()
        uploadRequest
            .responseDecodableObject(keyPath: "data") {[weak self] (response:
                DataResponse<Media>) in
        
                SVProgressHUD.dismiss()
                
        switch response.result {

            case .success(let media):
                self?.mediaId = media.id
            self?.addEpisode()
            case .failure(let error):
                print("FAILURE: \(error)")
        }

        }
    }
    
    private func addEpisode(){
        let token: String = self.token!
        let headers = ["Authorization": token]
        
        let parameters: [String: String] = [
            "showId": showId!,
            "mediaId": mediaId,
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
}

extension AddEpisodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            
            
//            if let asset = info[UIImagePickerControllerImageURL] as? URL {
//                let str = asset.deletingPathExtension().lastPathComponent
//
//                print(asset.pathExtension + " " + str)
//            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
}
