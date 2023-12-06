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
}
