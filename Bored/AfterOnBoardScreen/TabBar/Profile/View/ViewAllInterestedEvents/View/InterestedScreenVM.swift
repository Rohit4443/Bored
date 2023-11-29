//
//  InterestedScreenVM.swift
//  Bored
//
//  Created by Dharmani on 27/11/23.
//

import Foundation
import SVProgressHUD

protocol InterestedScreenVMObserver{
    func observerInterestListing()
}

class InterestedScreenVM: NSObject{
    
    var userData : GetProfileData?
    var interestedData: [EventListingData] = []
    var fileData: [FileData] = []
    var observer: InterestedScreenVMObserver?
    init(observer: InterestedScreenVMObserver? = nil) {
        self.observer = observer
    }
    
    func interestListingApi(){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.interestedEventListing, params: [:], success: {
            (response) in
            print(response)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted){
                do {
                    let userModel = try? JSONDecoder().decode(HomeListingModel.self, from: parsedData)
                } catch {
                    print(error)
                }
                if let userModel = try? JSONDecoder().decode(HomeListingModel.self, from: parsedData){
                    if let data = userModel.data{
                        self.interestedData.append(contentsOf: data)
                        self.observer?.observerInterestListing()
                    }else{
                        self.interestedData.removeAll()
                        self.observer?.observerInterestListing()
                    }
                   
                }
            }
        }, failure: {
            (error) in
                print(error.debugDescription)
        })
    }
    
}
