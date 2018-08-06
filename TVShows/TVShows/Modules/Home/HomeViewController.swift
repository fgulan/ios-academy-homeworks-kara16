
//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 19/07/2018.
//  Copyright © 2018 Filip Karacic. All rights reserved.

import UIKit
import Alamofire
import SVProgressHUD

class HomeViewController: UIViewController{
    //    MARK: - Public properties
    
    var loginUser: LoginData?
    
    //    MARK: - Private properties
    
    private var _shows: [Show] = []
    private var _isCollectionViewEnabled = true
    
    //    MARK: - IBOutlets
    
    @IBOutlet private weak var _collectionView: UICollectionView! {
        didSet {
            _collectionView.delegate = self
            _collectionView.dataSource = self
        }
    }
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Shows"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic-logout"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(_logoutActionHandler))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic-listview"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(_changeView))
        
        getShows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //    MARK: - Private methods
    
    private func goToLoginScreen(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController =
            storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        navigationController?.setViewControllers([loginViewController],
                                                 animated: true)
    }
    
    private func getShows(){
        let token: String = loginUser!.token
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request(Constants.URL.baseUrl + "/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:
                DataResponse<[Show]>) in
                
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success(let shows):
                    self?._shows = shows
                    self?._collectionView.reloadData()
                case .failure:
                    print("Fail")
                }
        }
    }
    
    //    MARK: - Private methods (objc)
    
    @objc private func _logoutActionHandler() {
        let domain = Bundle.main.bundleIdentifier!
        
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        goToLoginScreen()
    }
    
    @objc private func _changeView() {
        if _isCollectionViewEnabled{
            navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "ic-gridview")
            _isCollectionViewEnabled = false
        }else{
            navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "ic-listview")
            _isCollectionViewEnabled = true
        }
        
        _collectionView.reloadData()
    }
}

//  MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if _isCollectionViewEnabled{
            return CGSize(width: view.frame.width / 2.2, height: view.frame.height / 3)
        }else{
            return CGSize(width: view.frame.width, height: view.frame.height / 3)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = _shows[indexPath.row]
        
        jumpToShowDetails(show: show)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private func jumpToShowDetails(show: Show){
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(
            withIdentifier: "ShowDetailsViewController"
            ) as! ShowDetailsViewController
        
        detailsViewController.token = loginUser?.token
        detailsViewController.showId = show.id
        
        
        let navigationController = UINavigationController(rootViewController:
            detailsViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let show = _shows[indexPath.row]
        
        if _isCollectionViewEnabled{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",
                                                     for: indexPath) as! CollectionViewCell
            cell.configureWith(show: show)
            
            return cell
            
        }else{
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell",
                                                      for: indexPath) as! ListCollectionViewCell
            cell.configureWith(show: show)
            
            return cell
        }

    }
}

