//
//  BlockModel.swift
//  Bored
//
//  Created by Dharmani on 13/12/23.
//

import Foundation


class BlockModel: Codable{
    var status: Int?
    var message: String?
    var data: [BlockData]?
}

class BlockData: Codable{
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
    var image: String?
    var status: String?
    var email_verification: String?
    var verification_token: String?
    var device_type: String?
    var device_token: String?
    var latitude:String?
    var longitude: String?
    var is_private: String?
    var is_recent_search: String?
    var is_recent_location: String?
    var auth_key: String?
    var access_token: String?
    var created_at: String?
    var updated_at: String?
}
