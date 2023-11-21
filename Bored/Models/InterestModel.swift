//
//  InterestModel.swift
//  Bored
//
//  Created by Dharmani on 21/11/23.
//

import Foundation

class InterestModel: Codable{
    var status: Int?
    var message: String?
    var data: [InterestListing]?
}

class InterestListing: Codable{
    var interest_id: String?
    var user_id: String?
    var interest_name: String?
    var created_at: String?
    var updated_at: String?
    var status: String?
}
