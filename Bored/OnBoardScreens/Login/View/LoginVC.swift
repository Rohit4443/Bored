//
//  LoginVC.swift
//  Bored
//
//  Created by Dr.mac on 20/10/23.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkUncheckButton: UIButton!
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

    }


    //MARK: - IBAction -
    @IBAction func checkUnchekAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.setBackgroundImage(UIImage(named: "ic_uncheck"), for: .selected)
    }
    
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let vc = ForgotPasswordVC()
        self.navigationController?.navigationBar.isHidden = true
        self.pushViewController(vc, true)
        
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        let window: UIWindow? = HEIGHT.window
                 let vc = TabBarVC()
                 window?.rootViewController = vc
                 window?.frame = UIScreen.main.bounds
                 window?.makeKeyAndVisible()
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = signUpVC()
        self.pushViewController(vc, true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
