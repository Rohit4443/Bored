//
//  MyEventVM.swift
//  Bored
//
//  Created by Dharmani on 01/12/23.
//

import Foundation
import SVProgressHUD

protocol MyEventVMObserver{
    func observerDeleteEvent()
}

class MyEventVM: NSObject{
    
    var observer: MyEventVMObserver?
    
    init(observer: MyEventVMObserver? = nil) {
        self.observer = observer
    }
    
    func deleteEventParams(eventID: String) -> [String:Any]{
        let params: [String: Any] = [
            "event_id": eventID
        ]
        print(params)
        return params
    }
    
    func deleteEventApi(eventID: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.deleteEvent, params:deleteEventParams(eventID: eventID), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.observerDeleteEvent()
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
