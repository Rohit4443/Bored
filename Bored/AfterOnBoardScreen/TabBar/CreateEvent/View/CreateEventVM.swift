//
//  CreateEventVM.swift
//  Bored
//
//  Created by Dharmani on 30/11/23.
//

import Foundation
import SVProgressHUD

protocol CreateEventVMObserver{
    func observerCreateEvent()
    func observerEditEvent()
}

class CreateEventVM: NSObject{
    
    var observer: CreateEventVMObserver?
    var createEvent: CreateEventData?
    init(observer: CreateEventVMObserver? = nil) {
        self.observer = observer
    }
    
    func createEventParam(title: String,description: String, startDate: String, endDate: String, endTime: String, startTime: String,location: String,latitude: String,longitude: String,eventTag: String, files: [Data],thumbImage: String,type: String) -> [String:Any]{
        let params: [String: Any] = [
            "title": title,
            "description": description,
            "start_date": startDate,
            "end_date": endDate,
            "start_time": startTime,
            "end_time": endTime,
            "location": location,
            "latitude": latitude,
            "longitude": longitude,
            "event_tags": eventTag,
            "files": files,
            "thumb_images": thumbImage,
            "type": type
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func editEventParams(title: String,description: String, startDate: String, endDate: String, endTime: String, startTime: String,location: String,latitude: String,longitude: String,eventTag: String, files: [Data],thumbImage: String,type: String, eventID: String) -> [String: Any]{
        let params: [String: Any] = [
            "title": title,
            "description": description,
            "start_date": startDate,
            "end_date": endDate,
            "start_time": startTime,
            "end_time": endTime,
            "location": location,
            "latitude": latitude,
            "longitude": longitude,
            "event_tags": eventTag,
            "files": files,
            "thumb_images": thumbImage,
            "type": type,
            "event_id": eventID
        ]
        print("parameters:-  \(params)")
        return params
        
    }
    
    func createEventApi(title: String,description: String, startDate: String, endDate: String, endTime: String, startTime: String,location: String,latitude: String,longitude: String,eventTag: String, files: [Data],thumbImage: String,type: String){
        SVProgressHUD.show()
        let imageKeys: [String] = files.enumerated().map { "files[\($0.offset)]" }
        print(imageKeys)
        AFWrapperClass.sharedInstance.requestMultipleImagesPOST(Constant.createEvent, params: createEventParam(title: title, description: description, startDate: startDate, endDate: endDate, endTime: endTime, startTime: startTime, location: location, latitude: latitude, longitude: longitude, eventTag: eventTag, files: files, thumbImage: thumbImage, type: type), imageKeys: imageKeys, imageDatas: files, success: {
            (reponse) in
            print(reponse)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: reponse,options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(CreateEventModel.self, from: parsedData)
                    let data = userModel.data
                       self.createEvent = data
                       print(self.createEvent)
                   self.observer?.observerCreateEvent()
                } catch{
                    print(error)
                }
            }
  
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
    }
    
    func editEventApi(title: String,description: String, startDate: String, endDate: String, endTime: String, startTime: String,location: String,latitude: String,longitude: String,eventTag: String, files: [Data],thumbImage: String,type: String,eventId: String){
        SVProgressHUD.show()
        let imageKeys: [String] = files.enumerated().map { "files[\($0.offset)]" }
        print(imageKeys)
        AFWrapperClass.sharedInstance.requestMultipleImagesPOST(Constant.editEvent, params: editEventParams(title: title, description: description, startDate: startDate, endDate: endDate, endTime: endTime, startTime: startTime, location: location, latitude: latitude, longitude: longitude, eventTag: eventTag, files: files, thumbImage: thumbImage, type: type, eventID: eventId), imageKeys: imageKeys, imageDatas: files, success: {
            (reponse) in
            print(reponse)
            SVProgressHUD.dismiss()
            if let parsedData = try? JSONSerialization.data(withJSONObject: reponse,options: .prettyPrinted){
                do{
                    let userModel = try JSONDecoder().decode(CreateEventModel.self, from: parsedData)
                    let data = userModel.data
                       self.createEvent = data
                       print(self.createEvent)
                   self.observer?.observerEditEvent()
                } catch{
                    print(error)
                }
            }
  
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
    }
}
