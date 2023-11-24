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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var viewModel: ProfileVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        setProfileData()
        setViewModel()
        print(UserDefaultsCustom.getUserData()?.image)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setViewModel()
    }
    func setTableView(){
        self.interestedEventsTableView.delegate = self
        self.interestedEventsTableView.dataSource = self
        self.interestedEventsTableView.register(UINib(nibName: "ProfileEventsTVCell", bundle: nil), forCellReuseIdentifier: "ProfileEventsTVCell")
    
    }
    
    func setProfileData(){
        self.nameLabel.text = "\(UserDefaultsCustom.getUserData()?.first_name ?? "")\(" ")\(UserDefaultsCustom.getUserData()?.last_name ?? "")"
        self.emailLabel.text = UserDefaultsCustom.getUserData()?.email
        self.profileImage.setImage(image: UserDefaultsCustom.getUserData()?.image,placeholder: UIImage(named: "placeholder"))
    }
   
    func setViewModel(){
        self.viewModel = ProfileVM(observer: self)
        viewModel?.getProfileApi()
        interestedEventsTableView.reloadData()
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
//        return 2
        return viewModel?.interestEvent.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEventsTVCell", for: indexPath) as! ProfileEventsTVCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension ProfileVC: ProfileVMObserver{
    func observerGetProfile() {
        if viewModel?.interestEvent.count ?? 0 > 0 {
            self.interestedEventsTableView.backgroundView = nil
        } else {
            self.interestedEventsTableView.setBackgroundView(message: "No data found.")
        }
        self.interestedEventsTableView.reloadData()
    }
    
}
