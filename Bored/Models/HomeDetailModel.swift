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
    var id: String?
    var first_name: String?
    var last_name: String?
    var name: String?
    var email: String?
    var password: String?
    var about_me: String?
    var interests: String?
    var dob: String?
    var gender: String?
    var image: String
    var status: String?
    var email_verification: String?
    var verification_token: String?
    var device_type: String?
    var device_token: String?
    var latitude:String?
    var longitude: String?
    var is_private:String?
    var auth_key: String?
    var access_token: String?
    var created_at: String?
    var updated_at: String?
}
