//
//  LoginVM.swift
//  Bored
//
//  Created by Dharmani on 21/11/23.
//

import Foundation
import Kingfisher
import SVProgressHUD

protocol LoginVMObserver{
    func observerLoginApi()
}

class LoginVM: NSObject{
    
    var observer: LoginVMObserver?
     
    init(observer: LoginVMObserver? = nil) {
        self.observer = observer
    }
    
    func loginParameters(email: String, password: String,  deviceType: String) -> [String:Any]{
        let deviceToken = UserDefaultsCustom.getDeviceToken()
        let params : [String:Any] = [
            "email"       : email,
            "password"    : password,
            "device_type" : deviceType,
            "device_token" : deviceToken,
        ]
        print("parameters:-  \(params)")
        return params
       
    }
    func loginApi(email: String, password: String, deviceType: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.login, params:loginParameters(email: email, password: password, deviceType: deviceType) , success: {
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
                        AppDefaults.token = "\("Bearer ")\(userModel.data?.access_token ?? "")"
                    }
                }
            }
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerLoginApi()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .error)
            }
        }, failure: { (error) in
            print(error.debugDescription)
        })
        
    }
    
}
