//
//  SelectLoginSignUpVC.swift
//  Bored
//
//  Created by Dr.mac on 20/10/23.
//

import UIKit

class SelectLoginSignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func loginAction(_ sender: UIButton) {
        let vc = LoginVC()
        self.pushViewController(vc, true)
        self.navigationController?.navigationBar.isHidden = true
    }
  
  
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = signUpVC()
        self.pushViewController(vc, true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
