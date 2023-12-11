//
//  BlockReportPopUpVC.swift
//  Bored
//
//  Created by Dr.mac on 27/10/23.
//

import UIKit
protocol BlockReportPopUpVCDelegate{
    func blockUserAction()
}

class BlockReportPopUpVC: UIViewController {
    @IBOutlet weak var blockUserButton: UIButton!
    @IBOutlet weak var reportUserLabel: UIButton!
    
    @IBOutlet var mainBgView: UIView!
    //MARK: - Variables -
    var delegate: BlockReportPopUpVCDelegate?
    var controller: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissPopUpOnViewTap()
    }
 
    func dismissPopUpOnViewTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapgesture))
        mainBgView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapgesture(){
       dismiss(animated: true)
    }
    //MARK: - IBAction -
    @IBAction func blockUserAction(_ sender: UIButton) {
//        dismiss(animated: true)
        self.delegate?.blockUserAction()
//        let vc = BlockedUserVC()
//        self.controller?.pushViewController(vc, true)
    }
    
    @IBAction func reportAction(_ sender: UIButton) {
        dismiss(animated: true)
        let vc = ReportUserPopupVC()
        vc.modalPresentationStyle = .overFullScreen
        self.controller?.present(vc, true)
    }
}
