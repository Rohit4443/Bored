//
//  MapVM.swift
//  Bored
//
//  Created by Dharmani on 01/12/23.
//

import Foundation
import SVProgressHUD

protocol MapVMObserver{
    func observerMapListing()
    func mapVisisbility(isPrivate: String)
}


class MapVM: NSObject{
    
    var observer: MapVMObserver?
    var mapListingData: [MapListingData] = []
    
    
    init(observer: MapVMObserver? = nil) {
        self.observer = observer
    }
    
    func mapListingParams(lat: String,long: String) -> [String:Any] {
        let params: [String:Any] = [
            "lat": lat,
            "log": long
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func mapVisibilityParam(isPrivate: String) -> [String: Any]{
        let params: [String:Any] = [
            "is_private": isPrivate
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    
    func mapListingApi(lat: String, long: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.mapListing, params: mapListingParams(lat: lat, long: long), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            
            if let parsedData = try? JSONSerialization.data(withJSONObject: response,options: .prettyPrinted){
                do{
                    if let userModel = try? JSONDecoder().decode(MapListingModel.self, from: parsedData){
                        if let data = userModel.data{
                            print(data)
                            
                            self.mapListingData.append(contentsOf: data)
    //                        self.eventData = data
                            self.observer?.observerMapListing()
                            
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
    
    func mapVisibilityApi(isPrivate: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.mapVisibility, params: mapVisibilityParam(isPrivate: isPrivate), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            
            if let parsedData = try? JSONSerialization.data(withJSONObject: response,options: .prettyPrinted){
                do{
                    if let userModel = try? JSONDecoder().decode(MapVisibilityModel.self, from: parsedData){
                        if let data = userModel.is_private{
                            print(data)
                        
                            self.observer?.mapVisisbility(isPrivate: data)
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
