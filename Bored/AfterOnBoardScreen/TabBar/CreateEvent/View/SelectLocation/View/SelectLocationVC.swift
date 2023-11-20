//
//  SelectLocationVC.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit

class SelectLocationVC: UIViewController {
    @IBOutlet weak var selectLocationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewDelegates()
            
        }
        
        func setTableViewDelegates(){
            selectLocationTableView.delegate = self
            selectLocationTableView.dataSource = self
            selectLocationTableView.register(UINib(nibName: "SelectLocationTVCell", bundle: nil), forCellReuseIdentifier: "SelectLocationTVCell")
            self.navigationController?.navigationBar.isHidden = true
            
        }
        
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    }
    

    extension SelectLocationVC : UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationTVCell", for: indexPath) as! SelectLocationTVCell
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
    }

