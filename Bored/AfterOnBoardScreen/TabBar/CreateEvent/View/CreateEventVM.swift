//
//  CreateEventVM.swift
//  Bored
//
//  Created by Dharmani on 30/11/23.
//

import Foundation

protocol CreateEventVMObserver{
    func observerCreateEvent()
}

class CreateEventVM: NSObject{
    
    var observer: CreateEventVMObserver?
    
    init(observer: CreateEventVMObserver? = nil) {
        self.observer = observer
    }
    
    func createEventParam(description: String, startDate: String, endDate: String, endTime: String, startTime: String,location: String,latitude: String,longitude: String,eventTag: String, files: Data,thumbImage: String,type: String) -> [String:Any]{
        let params: [String: Any] = [
            "description": description,
            "start_date": startDate,
            "end_date": endDate,
            "start_time": startTime,
            "end_time": endTime,
            "location": location,
            "latitude": latitude,
            "longitude": longitude,

        ]
        print("parameters:-  \(params)")
        return params
    }
}
