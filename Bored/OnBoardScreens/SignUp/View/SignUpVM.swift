//
//  SignUpVM.swift
//  Bored
//
//  Created by Dharmani on 20/11/23.
//

import Foundation
import Kingfisher
import SVProgressHUD

protocol SignUpVMObserver{
    func observerSignUpApi()
}

class SignUpVM: NSObject{
    var observer: SignUpVMObserver?
    
    init(observer: SignUpVMObserver){
        self.observer = observer
    }
    
    func signUpParameters(firstName: String, lastName: String, email: String, password: String, interests: String, gender: String,dob: String, deviceType: String, image: String, interestName: String) -> [String:Any]{
        let deviceToken = UserDefaultsCustom.deviceToken
        let params : [String:Any] = [
            "last_name"   : lastName,
            "first_name"  : firstName,
            "email"       : email,
            "password"    : password,
            "interests"   : interests,
            "gender"      : gender,
            "dob"         : dob,
            "device_type" : deviceType,
            "device_token" : deviceToken,
            "image": image,
            "interest_name": interestName
        ]
        print("parameters:-  \(params)")
        return params
       
    }
    
    func signUPApi(firstName: String, lastName: String, email: String, password: String, interests: String, gender: String,dob: String, deviceType: String, image: String, interestName: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.signUp, params: signUpParameters(firstName: firstName, lastName: lastName, email: email, password: password, interests: interests, gender: gender, dob: dob, deviceType: deviceType, image: image, interestName: interestName), success: {
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
                    }
                }
            }
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerSignUpApi()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
            }
        }, failure: { (error) in
            print(error.debugDescription)
        })
        
    }
    
}
