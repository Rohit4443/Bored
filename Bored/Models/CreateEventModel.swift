//
//  CreateEventModel.swift
//  Bored
//
//  Created by Dharmani on 19/12/23.
//

import Foundation

class CreateEventModel: Codable{
    var status: Int?
    var message: String?
    var data: CreateEventData?
    
}
class CreateEventData: Codable{
    var user_id: String?
    var title: String?
    var description: String?
    var start_date: String?
    var end_date: String?
    var start_time: String?
    var end_time: String?
    var location: String?
    var latitude: String?
    var longitude: String?
    var event_tags: String?
    var created_at: String?
    var updated_at: String?
    var status: String?
    var event_id: String?
    var files: [FileData]?
}
 
