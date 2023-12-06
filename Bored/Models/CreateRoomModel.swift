//
//  CreateRoomModel.swift
//  Bored
//
//  Created by Dharmani on 02/12/23.
//

import Foundation

class CreateRoomModel: Codable{
    
    var status: Int?
    var message: String?
    var data: CreateRoomData?
}
class CreateRoomData: Codable{
    var id: String?
    var sender_id: String?
    var receiver_id: String?
    var room_id: String?
    var delete_sender_id: String?
    var delete_receiver_id: String?
    var status: String?
    var created_at: String?
    var updatedAt: String?
}
