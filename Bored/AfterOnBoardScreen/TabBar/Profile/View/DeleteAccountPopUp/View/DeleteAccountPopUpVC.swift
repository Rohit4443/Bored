//
//  DeleteAccountPopUpVC.swift
//  Bored
//
//  Created by Dr.mac on 02/11/23.
//

import UIKit
protocol DeleteAccountPopUpVCDelegate{
    func deleteEvent(eventID:String)
}


class DeleteAccountPopUpVC: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var viewModel: ProfileVM?
    var viewModel1: MyEventVM?
    var comefrom:String?
    var controller:UIViewController?
    var eventID: String?
    
    var delegate: DeleteAccountPopUpVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        print(eventID)
    }
    override func viewWillAppear(_ animated: Bool) {
        if comefrom == "deleteAccount"{
            messageLabel.text = "Are you sure you want to delete this Account?"
            deleteAccountButton.setTitle("Delete Account", for: .normal)
        }else{
            messageLabel.text = "Are you sure you want to delete this Event?"
            deleteAccountButton.setTitle("Confirm", for: .normal)
        }
    }
    
    func setViewModel(){
        self.viewModel = ProfileVM(observer: self)
        self.viewModel1 = MyEventVM(observer: self)
    }
    
    @IBAction func deleteAccountAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        if comefrom == "deleteAccount"{
            viewModel?.deleteAccountApi()
//            let vc = SelectLoginSignUpVC()
//            self.controller?.pushViewController(vc, true)
        }else{
//            viewModel1?.deleteEventApi(eventID: eventID ?? "")
            self.delegate?.deleteEvent(eventID: eventID ?? "")
//            self.dismiss(animated: true)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
       
        if comefrom == "deleteAccount"{
            self.dismiss(animated: true)
        }else{
            self.dismiss(animated: true)
        }
    }
}
                                   
extension DeleteAccountPopUpVC : ProfileVMObserver{
    func observerGetProfile() {
        
    }
    
    func observerLogOut() {
        Singleton.shared.logoutFromDevice()
    }
          
            
}
extension DeleteAccountPopUpVC: MyEventVMObserver{
    func observerDeleteEvent() {
//        self.dismiss(animated: true)
        self.delegate?.deleteEvent(eventID: eventID ?? "")
    }
    
    
}
