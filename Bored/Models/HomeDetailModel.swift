//
//  HomeDetailModel.swift
//  Bored
//
//  Created by Dharmani on 27/11/23.
//

import Foundation
class HomeDetailModel: Codable{
    var status: Int?
    var message: String?
    var data: HomeDetailData?
}
class HomeDetailData: Codable{
    var event_id: String?
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
    var user_name: String?
    var user_image: String?
    var files: [FileData]?
    var event_tags_data: [InterestsDatum]?
    var interested_users: [InterestedUsersData]?
}
class InterestedUsersData: Codable{
    
}
