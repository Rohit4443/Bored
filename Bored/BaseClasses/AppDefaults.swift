//
//  AppDefaults.swift
//  Mongotdi
//
//  Created by apple on 21/09/22.
//

import Foundation
import UIKit
//import SKCountryPicker

struct AppDefaults {

    static var deviceToken:String?{
        set{
            UserDefaults.standard.set(newValue, forKey: "deviceToken")
        }
        get{
            return UserDefaults.standard.string(forKey: "deviceToken") ?? "1234"
        }
    }
    
    static var token : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "Authorization")
        }
        get{
            UserDefaults.standard.string(forKey: "Authorization")
        }
    }
    static var userLogin_status : Int?{
        set{
            UserDefaults.standard.set(newValue,forKey: "login_status")
        }
        get{
            UserDefaults.standard.integer(forKey: "login_status")
        }
    }
    
    static var loginRole : Int?{
        set{
            UserDefaults.standard.set(newValue,forKey: "loginRole")
        }
        get{
            UserDefaults.standard.integer(forKey: "loginRole")
        }
    }
   
    static var countryCode : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "code")
        }
        get{
            UserDefaults.standard.string(forKey: "code")
        }
    }
    static var phoneNumber : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "number")
        }
        get{
            UserDefaults.standard.string(forKey: "number")
        }
    }
    static var cellNumber : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "cellNumber")
        }
        get{
            UserDefaults.standard.string(forKey: "cellNumber")
        }
    }
    static var userName : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "name")
        }
        get{
            UserDefaults.standard.string(forKey: "name")
        }
    }
    static var userEmail : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "email")
        }
        get{
            UserDefaults.standard.string(forKey: "email")
        }
    }
    static var einNumber : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "einNumber")
        }
        get{
            UserDefaults.standard.string(forKey: "einNumber")
        }
    }
    static var userImage : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "image")
        }
        get{
            UserDefaults.standard.string(forKey: "image")
        }
    }
    static var countryName : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "country")
        }
        get{
            UserDefaults.standard.string(forKey: "country")
        }
    }
    static var companyIndividual : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "register_as")
        }
        get{
            UserDefaults.standard.string(forKey: "register_as")
        }
    }
    static var Travel : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "travel")
        }
        get{
            UserDefaults.standard.string(forKey: "travel")
        }
    }
    static var Ladder_work : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "Ladder")
        }
        get{
            UserDefaults.standard.string(forKey: "Ladder")
        }
    }
    
    static var Strike : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "strike")
        }
        get{
            UserDefaults.standard.string(forKey: "strike")
        }
    }
    
    static var userAddress : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "address")
        }
        get{
            UserDefaults.standard.string(forKey: "address")
        }
    }
    
    static var state : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "state")
        }
        get{
            UserDefaults.standard.string(forKey: "state")
        }
    }
    static var latitude : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "lat")
        }
        get{
            UserDefaults.standard.string(forKey: "lat")
        }
    }
    static var longitude : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "long")
        }
        get{
            UserDefaults.standard.string(forKey: "long")
        }
    }
    static var laborLatitude : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "laborL")
        }
        get{
            UserDefaults.standard.string(forKey: "laborL")
        }
    }
    static var laborLongitude : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "laborLong")
        }
        get{
            UserDefaults.standard.string(forKey: "laborLong")
        }
    }
    static var city : String?{
        set{
            UserDefaults.standard.set(newValue,forKey: "city")
        }
        get{
            UserDefaults.standard.string(forKey: "city")
        }
    }
    
//    static var countryData : Country?{
//        set{
//            UserDefaults.standard.set(newValue,forKey: "countryData")
//        }
//        get{
//            UserDefaults.standard.value(forKey: "countryData") as? Country
//        }
//    }
        
    func setAppDefaults<T>(_ value:T,key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getAppDefaults<T>(key:String) -> T? {
        guard let value = UserDefaults.standard.value(forKey: key) as? T else {
            return nil
        }
        return value
    }
    func getSAppDefault(key:String) -> Any{
        let value = UserDefaults.standard.value(forKey: key)
        return value as Any
    }
    func removeAppDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    
//    static func labourProfileData(labourProfileData:LaborSignupModel) {
//        print("save user labourProfileData")
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(labourProfileData), forKey: "laborCheckModel")
//    }
    
    
    
//    static func getLabourProfileData() -> LaborSignupModel? {
//        if let data = UserDefaults.standard.value(forKey: "laborCheckModel") as? Data {
//            do {
//                let userData = try PropertyListDecoder().decode(LaborSignupModel.self, from: data)
//                return userData
//            } catch {
//                print(error)
//            }
//        }
//        return nil
//    }
//
    static func removeLabourProfileData() {
        if let data = UserDefaults.standard.value(forKey: "laborCheckModel") as? Data {
            UserDefaults.standard.removeObject(forKey: "laborCheckModel")
            UserDefaults.standard.synchronize()
        }
    }
    
    
//    static func companyProfileData(companyProfileData:LoginCheckDataModels) {
//        print("save user companyProfileData")
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(companyProfileData), forKey: "companyProfileData")
//    }
//
//    static func getCompanyProfileData() -> LoginCheckDataModels? {
//        if let data = UserDefaults.standard.value(forKey: "companyProfileData") as? Data {
//            do {
//                let userData = try PropertyListDecoder().decode(LoginCheckDataModels.self, from: data)
//                return userData
//            } catch {
//                print(error)
//            }
//        }
//        return nil
//    }
    
    static func removeCompanyProfileData() {
        if let data = UserDefaults.standard.value(forKey: "companyProfileData") as? Data {
            UserDefaults.standard.removeObject(forKey: "companyProfileData")
            UserDefaults.standard.synchronize()
        }
    }
    
    
}
