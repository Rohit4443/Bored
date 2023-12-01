//
//  MyEventDetailVM.swift
//  Bored
//
//  Created by Dharmani on 30/11/23.
//

import Foundation
import SVProgressHUD

protocol MyEventDetailVMObserver{
    func observerEventDetail()
}

class MyEventDetailVM: NSObject{
    
    var observer: MyEventDetailVMObserver?
    var imageData: [FileData]?
    var eventData: HomeDetailData?
    
    init(observer: MyEventDetailVMObserver? = nil) {
        self.observer = observer
    }
    
    func eventParam(eventID:String) -> [String:Any]{
        let params: [String:Any] = [
            "event_id": eventID
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func eventDetailApi(eventID: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.homeDetail, params: eventParam(eventID: eventID), success: {
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
                        self.eventData = data
                    }
                }
            }
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
//                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerEventDetail()
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
