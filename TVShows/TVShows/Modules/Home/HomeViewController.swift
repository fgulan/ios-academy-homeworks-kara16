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
    var loginUser: LoginData?
    private var shows: [Show] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          getShows()
        
        let logoutItem = UIBarButtonItem.init(image: UIImage(named:
            "ic-logout"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(_logoutActionHandler))
        
        navigationItem.leftBarButtonItem = logoutItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = "Shows"
    }
    
    @objc private func _logoutActionHandler() {
        let domain = Bundle.main.bundleIdentifier!
        
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        goToLoginScreen()
    }
    
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
                    self?.shows = shows
                    self?.tableView.reloadData()
                case .failure:
                    print("Fail")
                }
        }
    }
}

    extension HomeViewController: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let show = shows[indexPath.row]
            
            jumpToShowDetails(show: show)
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        private func jumpToShowDetails(show: Show){
            let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
            let detailsViewController = storyboard.instantiateViewController(
                withIdentifier: "ShowDetailsViewController"
                ) as! ShowDetailsViewController
            
            detailsViewController.token = loginUser?.token
            detailsViewController.showId = show.id
            
            
            let navigationController = UINavigationController.init(rootViewController:
                detailsViewController)
            present(navigationController, animated: true, completion: nil)
        }
        
    }
    
    extension HomeViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let cellDefaultHeight = CGFloat(160) /*the default height of the cell*/;
            let screenDefaultHeight = CGFloat(480)/*the default height of the screen i.e. 480 in iPhone 4*/;
            
            let factor = cellDefaultHeight/screenDefaultHeight
            
            return factor * (tableView.bounds.size.height)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
          return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return shows.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: TitleTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "TitleTableViewCell",
                for: indexPath
                ) as! TitleTableViewCell

            let show = shows[indexPath.row]
            cell.configureWith(show: show)
           
            return cell
        }
    }
