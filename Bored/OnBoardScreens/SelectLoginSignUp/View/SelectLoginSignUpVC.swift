//
//  SelectLoginSignUpVC.swift
//  Bored
//
//  Created by Dr.mac on 20/10/23.
//

import UIKit

class SelectLoginSignUpVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func loginAction(_ sender: UIButton) {
        if !sender.isSelected{
            loginBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            loginBtn.setTitleColor(.white, for: .normal)
            let vc = LoginVC()
            self.pushViewController(vc, true)
            self.navigationController?.navigationBar.isHidden = true
        }else{
            signUpBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            signUpBtn.setTitleColor(.black, for: .normal)
        }
        
    }
  
  
    @IBAction func signUpAction(_ sender: UIButton) {
        if !sender.isSelected{
            signUpBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            signUpBtn.setTitleColor(.white, for: .normal)
            let vc = signUpVC()
            self.pushViewController(vc, true)
            self.navigationController?.navigationBar.isHidden = true
        }else{
            loginBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            loginBtn.setTitleColor(.black, for: .normal)
        }
       
    }
    
}
