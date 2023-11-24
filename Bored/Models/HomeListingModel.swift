//
//  HomeListingModel.swift
//  Bored
//
//  Created by Dharmani on 24/11/23.
//

import Foundation


class HomeListingModel:Codable{
    var status: Int?
    var message: String?
    var data: [EventListingData]?
    
}
class EventListingData: Codable{
    var event_id: String?
    var user_id: String?
    var title: String?
    var description: String?
    var start_date: String?
    var end_date: String?
    var start_time:String?
    var end_time: String?
    var location: String?
    var latitude: String?
    var longitude: String?
    var event_tags: String?
    var created_at: String?
    var updated_at: String?
    var status: String?
    var user_name: String?
    var user_image: String?
    var files: [FileData]?
}
class FileData: Codable{
    var id:String?
    var event_id: String?
    var user_id: String?
    var files: String?
    var thumb_image: String?
    var type: String?
    var created_at: String?
    var updated_at: String?
    var status: String?
}

class interestedNotInterestedModel: Codable{
    var status: Int?
    var message: String?
//    var isInterested: Int?
}
