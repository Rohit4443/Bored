//
//  SignupImagesModel.swift
//  ADHoc
//
//  Created by apple on 21/03/23.
//

import Foundation

class SignupImagesModel: Codable{
    
    var id: Int?
    var user_id: Int?
    var images: String?
    var created_at: Int?
    
    func convertDict() -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        dict.setValue(id, forKey: "id")
        dict.setValue(user_id, forKey: "user_id")
        dict.setValue(images, forKey: "images")
        dict.setValue(created_at, forKey: "created_at")
        return dict
    }
}


class SignupImagesModels: Codable {
    
    var id: Int?
    var user_id: Int?
    var images: String?
    var created_at: Int?
    
    var data: Data?
    
    init(data: Data?) {
        self.data = data
    }
    
    func convertDict() -> NSMutableDictionary{
        let dict = NSMutableDictionary()
        dict.setValue(id, forKey: "id")
        dict.setValue(user_id, forKey: "user_id")
        dict.setValue(images, forKey: "images")
        dict.setValue(created_at, forKey: "created_at")
        return dict
    }
}
