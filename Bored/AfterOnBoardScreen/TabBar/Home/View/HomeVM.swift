//
//  HomeVM.swift
//  Bored
//
//  Created by Dharmani on 24/11/23.
//

import Foundation
import SVProgressHUD

protocol HomeVMObserver{
    func observerEventListing()
    func observerFilterEventListing()
    func observerinterestedNotInterested()
}

class HomeVM: NSObject{
    
    var observer: HomeVMObserver?
    var eventListing: [EventListingData] = []
    var fileListing: [FileData]?
    var interestedNotInterested: interestedNotInterestedModel?
    var perPage : Int = 1000
    var pageNo  : Int = 1
    
    init(observer: HomeVMObserver? = nil) {
        self.observer = observer
    }
    
    func eventParams(type: String, lat: String, long: String) -> [String:Any]{
        let params: [String:Any] = [
            "per_page": perPage,
            "page_no": pageNo,
            "type": type,
            "latitude": lat,
            "longitude": long
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func eventWithFilterParams(type: String, lat: String, long: String, disStart: String,disEnd: String, interest: String) -> [String:Any]{
        let params: [String:Any] = [
            "per_page": perPage,
            "page_no": pageNo,
            "type": type,
            "lat": lat,
            "log": long,
            "distance_start": disStart,
            "distance_end": disEnd,
            "interests": interest
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func interestedNotInterestedParams(eventId: String, type: String) -> [String:Any]{
        let params: [String: Any] = [
            "event_id": eventId,
            "type": type
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    
    func eventListingApi(type: String, lat: String,long: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.homeEventListing, params: eventParams(type: type, lat: lat,long: long), success: {
            (reponse) in
            print(reponse)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: reponse,options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(HomeListingModel.self, from: parsedData)
                } catch{
                    print(error)
                }
                if let userModel = try? JSONDecoder().decode(HomeListingModel.self, from: parsedData){
                    if let data = userModel.data{
//                        self.eventListing = data
                        self.eventListing.append(contentsOf: data)
                        print("Count=====\(self.eventListing.count)")
                        print(self.eventListing)
                        
                        
                    }else{
                        self.eventListing.removeAll()
                    }
                    self.observer?.observerEventListing()
                    self.pageNo += 1
                }
            }
            
            
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
    }
    func eventListingWithFilterApi(type: String, lat: String,long: String,disStart: String,disEnd: String, interest: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.homeEventWithFilter, params: eventWithFilterParams(type: type, lat: lat,long: long, disStart: disStart, disEnd: disEnd, interest: interest), success: {
            (reponse) in
            print(reponse)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: reponse,options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(HomeListingModel.self, from: parsedData)
                } catch{
                    print(error)
                }
                if let userModel = try? JSONDecoder().decode(HomeListingModel.self, from: parsedData){
                    if let data = userModel.data{
//                        self.eventListing = data
                        self.eventListing.append(contentsOf: data)
                        print("Count=====\(self.eventListing.count)")
                        print(self.eventListing)
                        
                        self.observer?.observerFilterEventListing()
                    }else{
//                        self.eventListing.removeAll()
                    }
                }
            }
            
            
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
    }
    
    
    
    func interestedNotInterestedApi(type: String, eventId: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.interestedNotInterested, params: interestedNotInterestedParams(eventId: eventId, type: type), success: {
            (reponse) in
            print(reponse)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: reponse,options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(interestedNotInterestedModel.self, from: parsedData)
                } catch{
                    print(error)
                }
                if let userModel = try? JSONDecoder().decode(interestedNotInterestedModel.self, from: parsedData){
                     let data = userModel
                        self.interestedNotInterested = data
                        print(self.eventListing)
                    self.observer?.observerinterestedNotInterested()
                    
                }
            }
  
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
    }
    
    
}
