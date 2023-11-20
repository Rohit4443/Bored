//
//  BlockedUserVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class BlockedUserVC: UIViewController {

    @IBOutlet weak var blockedUserTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blockedUserTableView.delegate = self
        blockedUserTableView.dataSource = self
        blockedUserTableView.register(UINib(nibName: "BlockedUserTVCell", bundle: nil), forCellReuseIdentifier: "BlockedUserTVCell")
        
        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    
}

extension BlockedUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedUserTVCell", for: indexPath) as! BlockedUserTVCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
    }
    
}
