//
//  EditProfileVM.swift
//  Bored
//
//  Created by Dharmani on 29/11/23.
//

import Foundation
import SVProgressHUD

protocol EditProfileVMObserver{
    func observerEditProfile()
}

class EditProfileVM: NSObject{
    
    var observer: EditProfileVMObserver?
    
    init(observer: EditProfileVMObserver? = nil) {
        self.observer = observer
    }
    
    func editParams(firstName: String, lastName: String, email: String,password: String, interest: String,gender: String,dob: String, deviceType: String,image: Data, intersetName: String,aboutMe:String) -> [String:Any]{
        let deviceToken = UserDefaultsCustom.getDeviceToken()
        let params: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password,
            "interests": interest,
            "gender": gender,
            "dob": dob,
            "device_type": deviceType,
            "device_token": deviceToken,
            "image": image,
            "interest_name": intersetName,
            "about_me": aboutMe
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func editProfileApi(firstName: String, lastName: String, email: String,password: String, interest: String,gender: String,dob: String, deviceType: String,image: Data, intersetName: String,aboutMe:String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestImagePOSTSURL(Constant.editProfile, params: editParams(firstName: firstName, lastName: lastName, email: email, password: password, interest: interest, gender: gender, dob: dob, deviceType: deviceType, image: image, intersetName: intersetName, aboutMe: aboutMe), imageKey: "image", imageData: image, success: {
            response in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                do {
                    let userModel = try JSONDecoder().decode(EditProfileModel.self, from: parsedData)
                    if let data = userModel.data {
                        print(data)
                        UserDefaultsCustom.saveProfileData(userData: data)
                    }
                } catch {
                    print(error)
                }
            }
            
            if let status = response["status"] as? Int, status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerEditProfile()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
            }
            
        }, failure: {
            error in
            print(error.debugDescription)
        })
    }
    
}

