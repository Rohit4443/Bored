//
//  SearchVM.swift
//  Bored
//
//  Created by Dharmani on 06/12/23.
//

import Foundation
import SVProgressHUD

protocol SearchVMObserver: NSObjectProtocol{
    func searchListing()
}


class SearchVM: NSObject{
    
    var observer: SearchVMObserver?
    var searchListing: [NotificationData] = []
    var recentSearchListing: [RecentSearchData] = []
    var perPage : Int = 1000
    var pageNo  : Int = 1
    
    init(observer: SearchVMObserver? = nil) {
        self.observer = observer
    }
    
    func SearchParams(search: String) -> [String:Any]{
        let params: [String:Any] = [
            "per_page": perPage,
            "page_no": pageNo,
            "search": search
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func getSearchListing(search: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.searchListing, params: SearchParams(search: search), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
                if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                    do {
                        let userModel = try JSONDecoder().decode(SearchModel.self, from: parsedData)
                        if let data = userModel.data {
    //                        self.interestData = data
                            self.searchListing.append(contentsOf: data)
                            print(self.searchListing.count)
                        } else {
                            self.searchListing.removeAll()
                        }
                        if let data1 = userModel.recentSearch {
    //                        self.interestData = data
                            self.recentSearchListing.append(contentsOf: data1)
                            print(self.recentSearchListing.count)
                        } else {
                            self.recentSearchListing.removeAll()
                        }
                        
                        self.observer?.searchListing()
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
