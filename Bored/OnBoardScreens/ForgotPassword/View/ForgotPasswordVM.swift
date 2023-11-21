//
//  ForgotPasswordVM.swift
//  Bored
//
//  Created by Dharmani on 21/11/23.
//

import Foundation
import Kingfisher
import SVProgressHUD

protocol ForgotPasswordVMObserver{
    func observerForgotApi()
}

class ForgotPasswordVM: NSObject{
    
    var observer: ForgotPasswordVMObserver?
    
    init(observer: ForgotPasswordVMObserver? = nil) {
        self.observer = observer
    }
    
    func forgotParams(email: String) -> [String: Any]{
        let params: [String: Any] = [
            "email": email
        ]
        print("parameters: --\(params)")
        return params
    }
    
    func forgotPasswordApi(email: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.forgotPassword, params: forgotParams(email: email), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(SignUp.self, from: parsedData)
                } catch{
                    print(error)
                }
                if let userModel = try? JSONDecoder().decode(SignUp.self, from: parsedData){
                    if let data = userModel.data{
                        print(data)
                        UserDefaultsCustom.saveUserData(userData: data)
                    }
                }
            }
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerForgotApi()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
            }
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
        
    }
    
}
