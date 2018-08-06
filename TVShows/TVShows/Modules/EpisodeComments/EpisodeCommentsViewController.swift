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
    
    //    MARK: - Public properties
    var token: String?
    var episodeId: String?
    
    //    MARK: - Private properties
    
    private let _emptyStateView = EmptyStateView.instanceFromNib()
    private var _originalBottomConstraintConstant: CGFloat?
    
    private let _refreshControl = UIRefreshControl()
    private var _isRefreshing = false
    
    private var _comments: [Comment] = []
    
    //    MARK: - IBOutlets
    
    @IBOutlet private weak var _viewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var _postCommentView: UIView!
    
    @IBOutlet private weak var _addCommentField: UITextField!
    @IBOutlet private weak var _tableView: UITableView!{
        didSet{
            _tableView.delegate = self
            _tableView.dataSource = self
            _tableView.refreshControl = _refreshControl
            
            _refreshControl.addTarget(self, action: #selector(refreshComments), for: .valueChanged)
            _refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
            _refreshControl.attributedTitle = NSAttributedString(string: "Refreshing comments ...")
        }
    }
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        _postCommentView.layer.borderColor = UIColor.lightGray.cgColor
        
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
    
    
    //    MARK: - IBActions
    
    @IBAction func postComment(_ sender: Any) {
        if _addCommentField.text!.isEmpty {
            _addCommentField.shake()
        }else{
            uploadComment(text: _addCommentField.text!)
        }
    }
    
   //    MARK: - Private methods
    
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
                    self?._comments = comments
                    self?._tableView.reloadData()
                    
                    if  self!._isRefreshing {
                        self?._refreshControl.endRefreshing()
                        self?._isRefreshing = false
                    }
                    
                case .failure:
                    print("Fail")
                }
        }
        
    }
    
    private func uploadComment(text: String){
        let token: String = self.token!
        let headers = ["Authorization": token]
        
        let parameters: [String: String] = [
            "text": _addCommentField.text!,
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
                    self?._addCommentField.text = ""
                    self?.getComments()
                case .failure:
                    print("Fail")
                }
        }
    }
    
    //    MARK: - Private methods (objc)
    
    @objc func refreshComments(){
        _isRefreshing = true
        getComments()
    }
    
    @objc func didSelectBackButton() {
        self.dismiss(animated: false)
    }
    
    @objc private func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self._originalBottomConstraintConstant = self._viewBottomConstraint.constant
            self._viewBottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    @objc private func keyboardWasHidden(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            if self._originalBottomConstraintConstant != nil{
                self._viewBottomConstraint.constant = self._originalBottomConstraintConstant!
            }
        })
    }
}

 //    MARK: - Extensions

extension EpisodeCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EpisodeCommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if _comments.count != 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else {
            tableView.backgroundView = _emptyStateView
            tableView.separatorStyle = .none
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeCommentTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "EpisodeCommentTableViewCell",
            for: indexPath
            ) as! EpisodeCommentTableViewCell
        
        let comment = _comments[indexPath.row]
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
