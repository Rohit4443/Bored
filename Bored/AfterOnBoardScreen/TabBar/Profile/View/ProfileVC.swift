//
//  ProfileVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var interestedEventsTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
    }
    func setTableView(){
        self.interestedEventsTableView.delegate = self
        self.interestedEventsTableView.dataSource = self
        self.interestedEventsTableView.register(UINib(nibName: "ProfileEventsTVCell", bundle: nil), forCellReuseIdentifier: "ProfileEventsTVCell")
    }
   
    @IBAction func settingAction(_ sender: UIButton) {
        let vc = SettingsVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    
    @IBAction func viewAllAction(_ sender: UIButton) {
        let vc = ViewAllInterestedEvents()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    @IBAction func editProfileAction(_ sender: UIButton) {
        let vc = EditProfileVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    
}
extension ProfileVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEventsTVCell", for: indexPath) as! ProfileEventsTVCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
