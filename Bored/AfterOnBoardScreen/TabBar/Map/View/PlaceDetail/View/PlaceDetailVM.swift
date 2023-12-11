//
//  PlaceDetailVM.swift
//  Bored
//
//  Created by Dharmani on 06/12/23.
//

import Foundation
import SVProgressHUD
protocol PlaceDetailVMObserver{
    func observerDetail()
    func blockUser()
}


class PlaceDetailVM: NSObject{
    
    var observer: PlaceDetailVMObserver?
    var mapDetail: MapListingData?
    
    
    init(observer: PlaceDetailVMObserver? = nil) {
        self.observer = observer
    }
    
    func deailParam(otherUserID: String) -> [String:Any] {
        let params: [String:Any] = [
            "other_user_id": otherUserID
        ]
        print("parameters:-  \(params)")
        return params
    }
    

    func mapDetailApi(otherUserID: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.mapListDetail, params: deailParam(otherUserID: otherUserID), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            
            if let parsedData = try? JSONSerialization.data(withJSONObject: response,options: .prettyPrinted){
                do{
                    if let userModel = try? JSONDecoder().decode(MapDetailModel.self, from: parsedData){
                        if let data = userModel.data{
                            print(data)
                            self.mapDetail = data
                            self.observer?.observerDetail()
                        }
                    }
                }catch{
                    print(error)
                }
                
            }
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
    }
    
    func blockUserParams(otherUserID: String, type: String) -> [String:Any]{
        let params: [String:Any] = [
            "other_user_id": otherUserID,
            "type": type
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func blockUserApi(otherUserID: String, type: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.blockUser, params: blockUserParams(otherUserID: otherUserID, type: type), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.blockUser()
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
