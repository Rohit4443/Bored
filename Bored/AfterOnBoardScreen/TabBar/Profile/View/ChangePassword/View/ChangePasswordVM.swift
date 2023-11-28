//
//  ChangePasswordVM.swift
//  Bored
//
//  Created by Dharmani on 28/11/23.
//

import Foundation
import SVProgressHUD

protocol ChangePasswordVMObserver{
    func observerChangePassword()
}

class ChangePasswordVM: NSObject{
    
    var observer: ChangePasswordVMObserver?
    init(observer: ChangePasswordVMObserver? = nil) {
        self.observer = observer
    }
    
    func changePasswordParams(oldPassword: String,newPassword: String) -> [String:Any]{
        let params: [String:Any] = [
            "new_password": newPassword,
            "old_password": oldPassword
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func changePasswordApi(oldPassword: String,newPassword: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.changePassword, params: changePasswordParams(oldPassword: oldPassword, newPassword: newPassword), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerChangePassword()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .error)
            }
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
        
    }
    
}
