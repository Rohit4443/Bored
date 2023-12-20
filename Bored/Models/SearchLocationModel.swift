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
    var userID: String?
    var otherUserID: String?
    var search: String?
    var type: String?
    var createdAt: String?
    var updatedAt: String?
}
class searchLocationData: Codable{
    
}
