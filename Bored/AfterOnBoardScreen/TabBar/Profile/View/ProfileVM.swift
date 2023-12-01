//
//  ProfileVM.swift
//  Bored
//
//  Created by Dharmani on 23/11/23.
//

import Foundation
import SVProgressHUD

protocol ProfileVMObserver{
    func observerGetProfile()
    func observerLogOut()
}

class ProfileVM: NSObject{
    
    var observer: ProfileVMObserver?
    var userData: GetProfileData?
    var interestEvent : [EventListingData] = []
    var interestData: [InterestsDatum] = []
    
    init(observer: ProfileVMObserver? = nil) {
        self.observer = observer
    }
    
    
    func getProfileApi(){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.getProfile, params: [:], success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response,options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(GetProfileModel.self, from: parsedData)
                } catch{
                    print(error)
                }
                if let userModel = try? JSONDecoder().decode(GetProfileModel.self, from: parsedData){
                    if let data1 = userModel.data{
                        print(data1)
                        self.userData = data1
                        UserDefaultsCustom.saveProfileData(userData: data1)
                    }
                    if let data2 = userModel.data?.interestsData{
                        self.interestData = data2
                    }
                    if let data = userModel.interestedEvents{
                        self.interestEvent.append(contentsOf: data)
                    }else{
                        self.interestEvent.removeAll()
                    }
                    self.observer?.observerGetProfile()
                }
            }
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
    }
    
    func logoutApi(){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.logout, params:[:], success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerLogOut()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .error)
            }
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
        
    }
    
    func deleteAccountApi(){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.deleteAccount, params:[:], success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerLogOut()
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

