//
//  ViewAllInterestedEvents.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class ViewAllInterestedEvents: UIViewController {
    @IBOutlet weak var ViewAllinterestedEventsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        
    }
    func setTableView(){
        self.ViewAllinterestedEventsTableView.delegate = self
        self.ViewAllinterestedEventsTableView.dataSource = self
        self.ViewAllinterestedEventsTableView.register(UINib(nibName: "ProfileEventsTVCell", bundle: nil), forCellReuseIdentifier: "ProfileEventsTVCell")
        
    }
   
    @IBAction func settingAction(_ sender: UIButton) {
        let vc = SettingsVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}
extension ViewAllInterestedEvents: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEventsTVCell", for: indexPath) as! ProfileEventsTVCell
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
