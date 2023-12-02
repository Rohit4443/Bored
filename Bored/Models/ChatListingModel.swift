//
//  ChatListingModel.swift
//  Bored
//
//  Created by Dharmani on 02/12/23.
//

import Foundation

class ChatListingModel: Codable{
    var status: Int?
    var message: String?
    var data: [ChatListingData]?
}
class ChatListingData: Codable{
    
    var id: Int?
    var sender_id: Int?
    var receiver_id: Int?
    var room_id: String?
    var delete_sender_id: Int?
    var delete_receiver_id: Int?
    var status: Int?
    var created_at: String?
    var updatedAt: String?
    var badgeCount: String?
    var LastMessage: String?
    var LastMessageTime: String?
    var userFirstName: String?
    var userLastName: String?
    var userImage: String?
}
