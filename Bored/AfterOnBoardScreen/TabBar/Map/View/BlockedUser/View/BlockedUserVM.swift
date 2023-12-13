//
//  BlockedUserVM.swift
//  Bored
//
//  Created by Dharmani on 12/12/23.
//

import Foundation
import SVProgressHUD

protocol BlockedUserVMObserver{
    func observerBlockList()
}

class BlockedUserVM: NSObject{
    
    var observer: BlockedUserVMObserver?
    var blockList: [BlockData] = []
    var perPage : Int = 1000
    var pageNo  : Int = 1
    
    init(observer: BlockedUserVMObserver? = nil) {
        self.observer = observer
    }
    
    func blockListParams(search: String) -> [String:Any]{
        let params: [String:Any] = [
            "search": search,
            "per_page": perPage,
            "page_no": pageNo
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func blockListApi(search: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.blockList, params: blockListParams(search: search), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
                if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                    do {
                        let userModel = try JSONDecoder().decode(BlockModel.self, from: parsedData)
                        if let data = userModel.data {
                            self.blockList.append(contentsOf: data)
                            print(self.blockList.count)
                        } else {
                            self.blockList.removeAll()
                        }

                        self.observer?.observerBlockList()
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
