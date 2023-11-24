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
}

class ProfileVM: NSObject{
    
    var observer: ProfileVMObserver?
    var interestEvent : [InterestsDatum] = []
    
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
                    }
                    if let data = userModel.data?.interestsData{
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
}

