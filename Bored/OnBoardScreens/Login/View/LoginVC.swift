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
    
    
    var viewModel: LoginVM?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setViewModel()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.text =  UserDefaults.standard.value(forKey: "USER_EMAIL") as? String
        passwordTextField.text =  UserDefaults.standard.value(forKey: "USER_PASSWORD") as? String
        passwordTextField.isSecureTextEntry = true
        self.checkUncheckButton.isSelected = emailTextField.text?.count ?? 0 > 0
    }
    
    func setViewModel(){
        self.viewModel = LoginVM(observer: self)
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
        
        let isValidEmail = Validator.validateEmail(candidate: emailTextField.text ?? "")
        let isValidPassword = Validator.validatePassword(password: passwordTextField.text ?? "")
        
        guard isValidEmail.0 == true else {
            Singleton.showMessage(message: isValidEmail.1, isError: .error)
            return
        }
        
        guard isValidPassword.0 == true else {
            Singleton.showMessage(message: isValidPassword.1, isError: .error)
            return
        }
        
        viewModel?.loginApi(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", deviceType: "1")
        
//        let window: UIWindow? = HEIGHT.window
//                 let vc = TabBarVC()
//                 window?.rootViewController = vc
//                 window?.frame = UIScreen.main.bounds
//                 window?.makeKeyAndVisible()
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = signUpVC()
        self.pushViewController(vc, true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func eyeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !sender.isSelected
        
    }
}
extension LoginVC: LoginVMObserver{
    func observerLoginApi() {
        if self.checkUncheckButton.isSelected == true {
            let text = self.emailTextField.text ?? ""
            let pass = self.passwordTextField.text ?? ""
            UserDefaults.standard.set(text, forKey:"USER_EMAIL")
            UserDefaults.standard.set(pass, forKey:"USER_PASSWORD")
            print("\(text) \(pass)")
        } else {
            UserDefaults.standard.removeObject(forKey: "USER_EMAIL")
            UserDefaults.standard.removeObject(forKey: "USER_PASSWORD")
        }
        
        let window: UIWindow? = HEIGHT.window
                 let vc = TabBarVC()
                 window?.rootViewController = vc
                 window?.frame = UIScreen.main.bounds
                 window?.makeKeyAndVisible()
    }
    
    
}
