//
//  SettingsVC.swift
//  Bored
//
//  Created by Dr.mac on 31/10/23.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    var arraySettingsName = ["Map Visibility","Change Password","My Events","Blocked User","About Us","Terms & Conditions","Privacy Policy","Delete Account","Logout"]
    var arraySettingsImages = ["ic_mapVisibility","ic_changePassword","ic_myEvent","ic_blockUser","ic_aboutUs","ic_termAndCondition","ic_privacyPolicy","ic_deleteAccount","ic_logout"]
    
    var viewModel : ProfileVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setTableViewDelegates()
        setViewModel()
        
    }
    
    func setViewModel(){
        self.viewModel = ProfileVM(observer: self)
    }
    
    func setTableViewDelegates(){
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UINib(nibName: "SettingsTVCell", bundle: nil), forCellReuseIdentifier: "SettingsTVCell")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
    }
    
}

extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySettingsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVCell", for: indexPath) as! SettingsTVCell
        cell.settingNameLabel.text = arraySettingsName[indexPath.row]
        cell.settingsIconImage.image = UIImage(named: arraySettingsImages[indexPath.row])
        
        if indexPath.row == 7{
            cell.settingNameLabel.textColor = .red
            cell.switchToggleButton.isHidden = true
            cell.nextForwardButton.setImage(UIImage(named: "ic_nextForwardRed"), for: .normal)
        }else if indexPath.row == 0{
            cell.nextForwardButton.isHidden = true
        }else{
            cell.switchToggleButton.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
           
            break;
        case 1:
            let vc = ChangePassword()
            self.navigationController?.pushViewController(vc, animated: true)
           
            
            break;
        case 2:
            let vc = MyEventVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
            
        case 3:
            let vc = BlockedUserVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
            
        case 4:
            
            break;
            
        case 5:
            
            break;
            
        case 6:
           
            break;
            
        case 7:
            let vc = DeleteAccountPopUpVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.controller = self
            vc.comefrom = "deleteAccount"
            self.present(vc, true)
            break;
            
        case 8:
            let alertController = UIAlertController(title: "Logout", message: "Are you sure, you want to logout?", preferredStyle: .alert)
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let actionYes = UIAlertAction(title: "Yes", style: .default) {_ in
                self.viewModel?.logoutApi()
//                let vc = SelectLoginSignUpVC()
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            alertController.addAction(actionNo)
            alertController.addAction(actionYes)
            present(alertController, animated: true, completion: nil)
            
            break;
            
        default:
            break;
            
        }
        
    }
    

}
extension SettingsVC: ProfileVMObserver{
    func observerGetProfile() {
       
    }
    
    func observerLogOut() {
        Singleton.shared.logoutFromDevice()
    }
    
    
}
