//
//  SearchUserVC.swift
//  Bored
//
//  Created by Dr.mac on 27/10/23.
//

import UIKit

class SearchUserVC: UIViewController {

    @IBOutlet weak var searchUserTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
            
        }
        
        func setTableViewDelegates(){
            searchUserTableView.delegate = self
            searchUserTableView.dataSource = self
            searchUserTableView.register(UINib(nibName: "SearchUserTVCell", bundle: nil), forCellReuseIdentifier: "SearchUserTVCell")
            self.navigationController?.navigationBar.isHidden = true
            
        }
        
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
        
    }
    

    extension SearchUserVC : UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTVCell", for: indexPath) as! SearchUserTVCell
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
    }

