//
//  ChangePassword.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit

class ChangePassword: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reEnterPassword: UITextField!
    
    var viewModel: ChangePasswordVM?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        
    }
    
    func setViewModel(){
        self.viewModel = ChangePasswordVM(observer: self)
    }
    

    //MARK: - IBAction -
    @IBAction func updatePassword(_ sender: UIButton) {
        let isValidOldPassword = Validator.validateOldPassword(password: oldPasswordTextField.text ?? "")
        let isValidNewPassword = Validator.validateNewPassword(password: newPasswordTextField.text ?? "")
        let isValidConfirmPassword = Validator.validateReEnterPassword(password: reEnterPassword.text ?? "")
        guard isValidOldPassword.0 == true else {
            Singleton.showMessage(message: isValidOldPassword.1, isError: .error)
            return
        }
        
        guard isValidNewPassword.0 == true else {
            Singleton.showMessage(message: isValidNewPassword.1, isError: .error)
            return
        }
        
        guard isValidConfirmPassword.0 == true else {
            Singleton.showMessage(message: isValidConfirmPassword.1, isError: .error)
            return
        }
        
        if newPasswordTextField.text != reEnterPassword.text {
            Singleton.showMessage(message: "New password and re-enter password not matched", isError: .error)
            
        } else {
            viewModel?.changePasswordApi(oldPassword: oldPasswordTextField.text ?? "", newPassword: newPasswordTextField.text ?? "")
            
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func oldPassEyeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        oldPasswordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func newPassEyeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        newPasswordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func rePassEyeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        reEnterPassword.isSecureTextEntry = !sender.isSelected
    }
    
}
extension ChangePassword: ChangePasswordVMObserver{
    func observerChangePassword() {
        self.popVC()
    }
    
    
}
