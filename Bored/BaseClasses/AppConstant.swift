//
//  AppConstant.swift
//  GoServe
//
//  Created by Dharmani Apps on 23/12/21.
//


import Foundation

let kAppName : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? String()
let kAppBundleIdentifier : String = Bundle.main.bundleIdentifier ?? String()
let baseUrl = "http://161.97.132.85/j3/bored/api/v1/"

enum DeviceType: String {
    case iOS = "iOS"
    case android = "android"
}

struct Constant {
    static let appName = "Bored"
    
    static let check = "rad"
    static let uncheck = "radio"
    static let iconLogo = "logo"
    static let iconMail = "mail"
    static let iconPassword = "password"
    
    //MARK: Bored
    
    static let signUp = baseUrl + "user/signup"
    static let interest = baseUrl + "user/interest-listing"
    static let login = baseUrl + "user/login"
    static let forgotPassword = baseUrl + "user/forgotpassword"
}


struct QLScreenName {
    static let subscribed = "subscribed"
    static let home = "home"
    static let settings = "settings"
}

enum FONT_NAMEs: String {
    case Amazon_Ember_Bold_Italic = "Amazon_Ember_Bold_Italic"
    case Amazon_Ember_Bold = "Amazon_Ember_Bold"
    case Amazon_Ember_Heavy_Italic = "Amazon_Ember_Heavy_Italic"
    case Amazon_Ember_Heavy = "Amazon_Ember_Heavy"
    case Amazon_Ember_Italic = "Amazon_Ember_Italic"
    case Amazon_Ember_Light_Italic = "Amazon_Ember_Light_Italic"
    case Amazon_Ember_Light = "Amazon_Ember_Light"
    case Amazon_Ember_Medium_Italic = "Amazon_Ember_Medium_Italic"
    case Amazon_Ember_Medium = "Amazon_Ember_Medium"
    case Amazon_Ember_Thin_Italic = "Amazon_Ember_Thin_Italic"
    case Amazon_Ember_Thin = "Amazon_Ember_Thin"
    case Amazon_Ember = "Amazon_Ember"
}


