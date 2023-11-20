//
//  EditDeleteEventPopUpVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class EditDeleteEventPopUpVC: UIViewController {
    
    @IBOutlet var containerView: UIView!
    
    var controller: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapgesture))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapgesture(){
        dismiss(animated: true)}
    
    @IBAction func editEventAction(_ sender: UIButton) {
        dismiss(animated: true)
        let vc = CreateEventVC()
        vc.comeFrom = "EditEvent"
        controller?.pushViewController(vc, true)
    }
    
    
    @IBAction func deleteEventAction(_ sender: UIButton) {
        dismiss(animated: true)
        let vc = DeleteAccountPopUpVC()
        controller?.modalPresentationStyle = .overFullScreen
        controller?.present(vc, true)
    }
    
}
