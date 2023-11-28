//
//  HomeDetailVM.swift
//  Bored
//
//  Created by Dharmani on 27/11/23.
//

import Foundation
import SVProgressHUD

protocol HomeDetailVMObserver{
    func observerHomeDetail()
}

class HomeDetailVM: NSObject{
    
    var observer : HomeDetailVMObserver?
    var imageData: [FileData]?
    var homeDetailData: HomeDetailData?
    
    init(observer: HomeDetailVMObserver? = nil) {
        self.observer = observer
    }
    
    func homeDetailParams(eventID: String) -> [String:Any]{
        let params: [String:Any] = [
            "event_id": eventID
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func homeDetailApi(eventID: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.homeDetail, params: homeDetailParams(eventID: eventID), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response,options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(HomeDetailModel.self, from: parsedData)
                }catch{
                    print(error)
                }
                if let userModel = try? JSONDecoder().decode(HomeDetailModel.self, from: parsedData){
                    if let data = userModel.data{
                        print(data)
                        self.homeDetailData = data
                        
                    }
                }
            }
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
//                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerHomeDetail()
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
