//
//  EpisodeCommentsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class EpisodeCommentsViewController: UIViewController {
    
    var token: String?
    var episodeId: String?
    
    private let emptyStateView = EmptyStateView.instanceFromNib()
    
    private let refreshControl = UIRefreshControl()
    private var isRefreshing = false
    
    private var comments: [Comment] = []
    
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    var originalBottomConstraintConstant: CGFloat?
    
    @IBOutlet weak var postCommentView: UIView!
    
    @IBOutlet weak var addCommentField: UITextField!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.refreshControl = refreshControl
            
            refreshControl.addTarget(self, action: #selector(refreshComments), for: .valueChanged)
            refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
            refreshControl.attributedTitle = NSAttributedString(string: "Refreshing comments ...")
        }
    }
    
    @objc func refreshComments(){
        isRefreshing = true
        getComments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        postCommentView.layer.borderColor = UIColor.lightGray.cgColor
        
        getComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = "Comments"
        
        var image = UIImage(named: "ic-navigate-back")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(didSelectBackButton))
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
    }
    
    @objc func didSelectBackButton() {
       self.dismiss(animated: false)
    }
    
    private func getComments(){
        let token: String = self.token!
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request(Constants.URL.baseUrl + "/episodes/" + episodeId! + "/comments",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:
                DataResponse<[Comment]>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let comments):
                    self?.comments = comments
                    self?.tableView.reloadData()
                    
                    if  self!.isRefreshing {
                        self?.refreshControl.endRefreshing()
                        self?.isRefreshing = false
                    }
                    
                case .failure:
                    print("Fail")
                }
        }
        
    }
    
    private func setTableViewBackground(){
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = "Sorry, we don't have comments yet. Be first who will write a review."
        messageLabel.numberOfLines = 0
        
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = .none;
    }

    @IBAction func postComment(_ sender: Any) {
        if addCommentField.text!.isEmpty {
            addCommentField.shake()
        }else{
            uploadComment(text: addCommentField.text!)
        }
    }
    
    private func uploadComment(text: String){
        let token: String = self.token!
        let headers = ["Authorization": token]
        
        let parameters: [String: String] = [
            "text": addCommentField.text!,
            "episodeId": episodeId!
        ]
        
        SVProgressHUD.show()
        
        Alamofire
            .request(Constants.URL.baseUrl + "/comments",
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseJSON() {[weak self] response in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success:
                    self?.addCommentField.text = ""
                    self?.getComments()
                case .failure:
                    print("Fail")
                }
        }
    }
    
    
    @objc private func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.originalBottomConstraintConstant = self.viewBottomConstraint.constant
            self.viewBottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    @objc private func keyboardWasHidden(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            if self.originalBottomConstraintConstant != nil{
                self.viewBottomConstraint.constant = self.originalBottomConstraintConstant!
            }
        })
    }
}

extension EpisodeCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EpisodeCommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if comments.count != 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else {
            tableView.backgroundView = emptyStateView
            tableView.separatorStyle = .none
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeCommentTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "EpisodeCommentTableViewCell",
            for: indexPath
            ) as! EpisodeCommentTableViewCell
        
        let comment = comments[indexPath.row]
        let image = chooseImage(commentsNumber: indexPath.row)
        cell.configureWith(comment: comment,image: image)
        
        return cell
    }
    
    private func chooseImage(commentsNumber: Int) -> UIImage{
     
        let novi = commentsNumber % 3
        
        switch novi{
        case 0: return #imageLiteral(resourceName: "img-placeholder-user1")
        case 1: return #imageLiteral(resourceName: "img-placeholder-user2")
        case 2: return #imageLiteral(resourceName: "img-placeholder-user3")
        default: return #imageLiteral(resourceName: "img-placeholder-user2")
        }
    }
}
