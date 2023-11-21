//
//  ForgotPasswordVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    var viewModel: ForgotPasswordVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        // Do any additional setup after loading the view.
    }

    func setViewModel(){
        self.viewModel = ForgotPasswordVM(observer: self)
    }

 
    @IBAction func submitAction(_ sender: UIButton) {
        let isValidEmail = Validator.validateEmail(candidate: emailTF.text ?? "")
        
        guard isValidEmail.0 == true else {
            Singleton.showMessage(message: isValidEmail.1, isError: .error)
            return
        }
        
        viewModel?.forgotPasswordApi(email: emailTF.text ?? "")
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
}
extension ForgotPasswordVC: ForgotPasswordVMObserver{
    func observerForgotApi() {
        self.popVC()
    }
    
    
}
