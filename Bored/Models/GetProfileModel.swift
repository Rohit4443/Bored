//
//  GetProfileModel.swift
//  Bored
//
//  Created by Dharmani on 23/11/23.
//

import Foundation

class GetProfileModel: Codable{
    var status: Int?
    var message: String?
    var data: GetProfileData?
    var interestedEvents: [EventListingData]?
}

class GetProfileData: Codable{
    var id: String?
    var first_name: String?
    var last_name: String?
    var name: String?
    var email: String?
    var password: String?
    var interests: String?
    var dob: String?
    var gender: String?
    var image: String?
    var status: String?
    var email_verification: String?
    var verification_token: String?
    var device_type: String?
    var device_token: String?
    var latitude: String?
    var longitude: String?
    var is_private: String?
    var auth_key:String?
    var access_token:String?
    var created_at: String?
    var updated_at: String?
    var about_me: String?
    var interestsData: [InterestsDatum]?
}

class InterestsDatum:Codable{
    var interest_id: String?
    var interest_name: String?
}

//class InterestedEventsData: Codable{
//    var event_id: String?
//    var userID: String?
//    var title: String?
//    var description: String?
//    var startDate: String?
//    var endDate: String?
//    var startTime: String?
//    var endTime: String?
//    var location: String?
//    var latitude: String?
//    var longitude: String?
//    var eventTags: String?
//    var createdAt: String?
//    var updatedAt: String?
//    var status: String?
//    var userName: String?
//    var userImage: String?
//    var files: [FileData]?
//
//}
