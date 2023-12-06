//
//  OneToOneChatVM.swift
//  Bored
//
//  Created by Dharmani on 04/12/23.
//

import Foundation
import SVProgressHUD

protocol OneToOneChatVMObserver{
    
    func sendMessageApi(message: SendMessageData, json: [String:Any])
    func getAllMessage()
    func updateMessage()
}

class OneToOneChatVM: NSObject{
    
    var observer: OneToOneChatVMObserver?
    var sendMeassage: SendMessageData?
    var userDetail: UserDetailData?
    var chatHistory: [SendMessageData] = []
    var perPage : Int = 1000
    var pageNo  : Int = 1
    
    init(observer: OneToOneChatVMObserver? = nil) {
        self.observer = observer
    }
    
    func sendMessageParams(recieverID: String, roomID: String,message: String, messageType: String,file: Data) -> [String:Any]{
        let params: [String:Any] = [
            "receiver_id": recieverID,
            "room_id": roomID,
            "message": message,
            "message_type": messageType,
            "files": file
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func sendMessageApi(recieverID: String, roomID: String,message: String, messageType: String,file: Data){
        
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestChatImagePOSTSURL(Constant.sendMessage, params: sendMessageParams(recieverID: recieverID, roomID: roomID, message: message, messageType: messageType, file: file), imageKey: "files", imageData: file, success: { response in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            
            if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                do {
                    let userModel = try JSONDecoder().decode(SendMessageModel.self, from: parsedData)
                    if let data = userModel.data {
                        let json = response["data"] as? JSON
                        print(data)
                        self.sendMeassage = data
                        self.observer?.sendMessageApi(message: data, json: json ?? [String:Any]())
                    }
                } catch {
                    print(error)
                }
            }
            
        }, failure: { error in
            print(error.debugDescription)
        })
    }
    
    func allMessageListParams(roomID: String) ->[String:Any]{
        let params: [String:Any] = [
            "room_id": roomID,
            "per_page": perPage,
            "page_no": pageNo + 1
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func allMessageListApi(roomID: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.allMessage, params: allMessageListParams(roomID: roomID), success: {
            (response) in
            print(response)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                do {
                    let userModel = try JSONDecoder().decode(GetAllMessagesModel.self, from: parsedData)
                        if let data = userModel.data {
                            self.chatHistory.append(contentsOf: data)
                        } else {
                            self.chatHistory.removeAll()
                        }
                        self.userDetail = userModel.userDetail
                        self.observer?.getAllMessage()
//                        self.pageNo += 1

                } catch {
                    print(error)
                }
            }
        }, failure: {
            (error) in
                print(error.debugDescription)
        })
        
    }
    func apiUpdateSeenStatus(roomID:String) {
       
        let params: [String:Any] = [
            "room_id"  : roomID
        ]
        print("Params in SearchUsers screen:-  \(params)")
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.updateMessage, params: params, success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
//                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.updateMessage()
            } else {
                let msg = response["message"] as? String
                self.observer?.updateMessage()
//                Singleton.showMessage(message: msg ?? "", isError: .error)
            }
        }, failure: {
            (error) in
            print(error.debugDescription)
            
        })
    }
    
    
}

