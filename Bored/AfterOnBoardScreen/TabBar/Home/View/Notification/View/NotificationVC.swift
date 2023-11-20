//
//  NotificationVC.swift
//  Bored
//
//  Created by Dr.mac on 26/10/23.
//

import UIKit

class NotificationVC: UIViewController {
    @IBOutlet weak var notificationShowTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()

    }
    func setTableViewDelegates(){
        notificationShowTableView.delegate = self
        notificationShowTableView.dataSource = self
        notificationShowTableView.register(UINib(nibName: "NotificationTVCell", bundle: nil), forCellReuseIdentifier: "NotificationTVCell")

    }
   

    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}


extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
