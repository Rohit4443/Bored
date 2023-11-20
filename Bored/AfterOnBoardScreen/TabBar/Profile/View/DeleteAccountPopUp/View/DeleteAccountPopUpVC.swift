//
//  DeleteAccountPopUpVC.swift
//  Bored
//
//  Created by Dr.mac on 02/11/23.
//

import UIKit

class DeleteAccountPopUpVC: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var comefrom:String?
    var controller:UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func deleteAccountAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        if comefrom == "deleteAccount"{
            

            let vc = SelectLoginSignUpVC()
            self.controller?.pushViewController(vc, true)
        }else{
            self.dismiss(animated: true)
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
