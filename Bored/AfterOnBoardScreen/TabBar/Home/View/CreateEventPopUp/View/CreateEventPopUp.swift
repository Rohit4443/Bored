//
//  CreateEventPopUp.swift
//  Bored
//
//  Created by Dr.mac on 26/10/23.
//

import UIKit

class CreateEventPopUp: UIViewController {
    @IBOutlet var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissPopUpOnViewTap()
    }
    
    func dismissPopUpOnViewTap(){
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapgesture))
        containerView.addGestureRecognizer(tapGesture)
        }
        @objc func tapgesture(){
           dismiss(animated: true)
            
        }

}
