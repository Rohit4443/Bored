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
    
    func signUpParameters(firstName: String, lastName: String, email: String, password: String, interests: String, gender: String,dob: String, deviceType: String, image: Data, interestName: String) -> [String:Any]{
        let deviceToken = UserDefaultsCustom.getDeviceToken()
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

    
    func signUPApi(firstName: String, lastName: String, email: String, password: String, interests: String, gender: String,dob: String, deviceType: String, image: Data, interestName: String){
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
                        UserDefaultsCustom.saveUserData(userData: data)
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

    
    
    
    func signUPImageApi(firstName: String, lastName: String, email: String, password: String, interests: String, gender: String, dob: String, deviceType: String, image: Data, interestName: String) {
        SVProgressHUD.show()
        
        // Convert image to data
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
//            print("Failed to convert image to data")
//            return
//        }
        
        // Prepare parameters for the API call
        let parameters: [String: Any] = signUpParameters(firstName: firstName, lastName: lastName, email: email, password: password, interests: interests, gender: gender, dob: dob, deviceType: deviceType, image: image, interestName: interestName)
        
        // Make the API call with the image data and other parameters
        AFWrapperClass.sharedInstance.requestImagePOSTSURL(Constant.signUp, params: parameters, imageKey: "image", imageData: image, success: { response in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            
            if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                do {
                    let userModel = try JSONDecoder().decode(SignUp.self, from: parsedData)
                    if let data = userModel.data {
                        print(data)
//                        UserDefaultsCustom.saveUserData(userData: data)
                    }
                } catch {
                    print(error)
                }
            }
            
            if let status = response["status"] as? Int, status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerSignUpApi()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
            }
        }, failure: { error in
            print(error.debugDescription)
        })
    }

    
}
