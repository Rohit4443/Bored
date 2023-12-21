//
//  SearchLocationModel.swift
//  Bored
//
//  Created by Dharmani on 20/12/23.
//

import Foundation

class SearchLocationModel: Codable{
    var status: Int?
    var message: String?
    var recentSearch: [RecentSearchLocationData]?
    var data: [searchLocationData]?

}
class RecentSearchLocationData: Codable{
    var id: String?
    var user_id: String?
    var other_user_id: String?
    var search: String?
    var latitude: String?
    var longitude: String?
    var type: String?
    var created_at: String?
    var updated_at: String?
}
class searchLocationData: Codable{
    
}
