//
//  NotificationVM.swift
//  Bored
//
//  Created by Dharmani on 06/12/23.
//

import Foundation
import SVProgressHUD

protocol NotificationVMObserver: NSObjectProtocol{
    func getListing()
}


class NotificationVM: NSObject{
    
    var observer: NotificationVMObserver?
    var notificationListing: [NotificationData] = []
    var perPage : Int = 1000
    var pageNo  : Int = 1
    
    init(observer: NotificationVMObserver? = nil) {
        self.observer = observer
    }
    
    func notificationParams() -> [String:Any]{
        let params: [String:Any] = [
            "per_page": perPage,
            "page_no": pageNo
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func getNotification(){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.NotificationList, params: notificationParams(), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
                if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                    do {
                        let userModel = try JSONDecoder().decode(NotificationModel.self, from: parsedData)
                        if let data = userModel.data {
    //                        self.interestData = data
                            self.notificationListing.append(contentsOf: data)
                            print(self.notificationListing.count)
                        } else {
                            self.notificationListing.removeAll()
                        }
                        self.observer?.getListing()
                        self.pageNo += 1
                    } catch {
                        print(error)
                    }
                   
                }
        }, failure: {
            (error) in
                print(error.debugDescription)
        })
    }
    
}
