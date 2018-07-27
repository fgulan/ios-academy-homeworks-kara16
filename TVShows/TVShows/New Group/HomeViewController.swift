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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Shows"
      
    }
    
    
    private func getShows(){
        let token: String = loginUser!.token
        let headers = ["Authorization": token]
        
        SVProgressHUD.show()
        
        Alamofire
            .request("https://api.infinum.academy/api/shows",
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
        
        /*
         Now, we are using autosizing via autolayout, if you want custom size override this function.
         And also, check other methods from `UITableViewDelegate`
         */
        //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return 90
        //    }
    }
    
    extension HomeViewController: UITableViewDataSource {
        
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
