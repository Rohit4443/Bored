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
    func recentSearch()
    func deleteRecentSearch()
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
    
    func SearchParams(search: String, isRecentSearch: String) -> [String:Any]{
        let params: [String:Any] = [
            "per_page": perPage,
            "page_no": pageNo,
            "search": search,
            "is_recent_search": isRecentSearch
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func getSearchListing(search: String, isRecentSearch: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.searchListing, params: SearchParams(search: search, isRecentSearch: isRecentSearch), success: {
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
    
    func recentSearchParams(otherUserId: String, isRecentSearch: String,search: String) -> [String:Any]{
        
        let params: [String:Any] = [
            "other_user_id": otherUserId,
            "is_recent_search": isRecentSearch,
            "search": search
        ]
        print("parameters:-  \(params)")
        return params
        
    }
    
    func recentSearchApi(otherUserId: String, isRecentSearch: String,search: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.recentSearch, params: recentSearchParams(otherUserId: otherUserId, isRecentSearch: isRecentSearch, search: search), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.recentSearch()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .error)
            }
        }, failure: {
            (error) in
                print(error.debugDescription)
        })
    }
    
    func deleteParams(otherUserId: String, isRecentSearch: String,search: String) -> [String:Any]{
        let params: [String:Any] = [
            "other_user_id": otherUserId,
            "is_recent_search": isRecentSearch,
            "search": search
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    
    func deleteRecentSearch(otherUserId: String, isRecentSearch: String,search: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.deleteRecent, params: recentSearchParams(otherUserId: otherUserId, isRecentSearch: isRecentSearch, search: search), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.deleteRecentSearch()
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
