//
//  ChatListingVM.swift
//  Bored
//
//  Created by Dharmani on 02/12/23.
//

import Foundation
import SVProgressHUD

protocol ChatListingVMObserver{
    func observerChatListing()
    func createRoom()
    func chatDelete()
}

class ChatListingVM: NSObject{
    
    var observer: ChatListingVMObserver?
    var chatListData: [ChatListingData] = []
    var chatRoomData: CreateRoomData?
    var perPage : Int = 1000
    var pageNo  : Int = 1
    
    init(observer: ChatListingVMObserver? = nil) {
        self.observer = observer
    }
    
    
    func chatListParams(search: String) -> [String:Any]{
        let params: [String:Any] = [
            "search": search,
            "per_page": perPage,
            "page_no": pageNo
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func getChatListing(search: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.chatListing, params: chatListParams(search: search), success: {
            (response) in
            print(response)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                do {
                    let userModel = try JSONDecoder().decode(ChatListingModel.self, from: parsedData)
                        if let data = userModel.data {
                            self.chatListData.append(contentsOf: data)
                        } else {
                            self.chatListData.removeAll()
                        }
                        self.observer?.observerChatListing()
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
    
    func chatRoomParam(receiverId: String) -> [String:Any]{
        let params: [String:Any] = [
            "receiver_id" : receiverId
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func createChatRoomApi(receiverId: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.createRoom, params: chatRoomParam(receiverId: receiverId), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response,options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(CreateRoomModel.self, from: parsedData)
                        if let data = userModel.data{
                            print(data)
                            self.chatRoomData = data
                            self.observer?.createRoom()
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
    
    func chatDeleteParams(roomID: String) -> [String: Any]{
        let params: [String:Any] = [
            "room_id" : roomID
        ]
        print("parameters:-  \(params)")
        return params
    }
    func chatDeleteApi(roomID: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.chatDelete, params: chatDeleteParams(roomID: roomID), success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.chatDelete()
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
