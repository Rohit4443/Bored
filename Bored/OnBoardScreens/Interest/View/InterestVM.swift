//
//  InterestVM.swift
//  Bored
//
//  Created by Dharmani on 21/11/23.
//

import Foundation
import SVProgressHUD

protocol InterestVMObserver: NSObjectProtocol{
    func getListing()
}

class InterestVM: NSObject{
    
    var observer: InterestVMObserver?
    var interestData: [InterestListing] = []
    var perPage : Int = 1000
    var pageNo  : Int = 1
    
    init(observer: InterestVMObserver? = nil) {
        self.observer = observer
    }
    
    func interestParams() -> [String:AnyObject]{
        let params : [String:AnyObject] = [
            "per_page"   : perPage as AnyObject,
            "pageNo"  : pageNo as AnyObject
            
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func getEventInterest(){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestSignUpInterestPOSTSURL(Constant.interest, params: interestParams(), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
                if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                    do {
                        let userModel = try JSONDecoder().decode(InterestModel.self, from: parsedData)
                    } catch {
                        print(error)
                    }
                    if let userModel = try? JSONDecoder().decode(InterestModel.self, from: parsedData) {
                        if let data = userModel.data {
    //                        self.interestData = data
                            self.interestData.append(contentsOf: data)
                        } else {
                            self.interestData.removeAll()
                        }
                        self.observer?.getListing()
                        self.pageNo += 1
                    }
                }
        }, failure: {
            (error) in
                print(error.debugDescription)
        })
    }
    
    
    
    
    func getInterest(){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.interest, params: interestParams(), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
                if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                    do {
                        let userModel = try JSONDecoder().decode(InterestModel.self, from: parsedData)
                    } catch {
                        print(error)
                    }
                    if let userModel = try? JSONDecoder().decode(InterestModel.self, from: parsedData) {
                        if let data = userModel.data {
    //                        self.interestData = data
                            self.interestData.append(contentsOf: data)
                        } else {
                            self.interestData.removeAll()
                        }
                        self.observer?.getListing()
                        self.pageNo += 1
                    }
                }
        }, failure: {
            (error) in
                print(error.debugDescription)
        })
    }
    
    
    func getMyInterest() {
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestGETURL(Constant.interest, params: interestParams() , success: { (response) in
            print(response)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                do {
                    let userModel = try JSONDecoder().decode(InterestModel.self, from: parsedData)
                } catch {
                    print(error)
                }
                if let userModel = try? JSONDecoder().decode(InterestModel.self, from: parsedData) {
                    if let data = userModel.data {
//                        self.interestData = data
                        self.interestData.append(contentsOf: data)
                    } else {
                        self.interestData.removeAll()
                    }
                    self.observer?.getListing()
                    self.pageNo += 1
                }
            }
        }, failure: { (error) in
            print(error.debugDescription)
        })
    }
    
}
