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
    static let getProfile = baseUrl + "user/getprofile"
    static let homeEventListing = baseUrl + "event/all-event-listing"
    static let interestedNotInterested = baseUrl + "event/interested-not-interested-events"
    static let homeDetail = baseUrl + "event/get-event-details"
    static let interestedEventListing = baseUrl + "event/get-interested-events"
    static let changePassword = baseUrl + "user/changepassword"
    static let logout = baseUrl + "user/logout"
    static let deleteAccount = baseUrl + "user/del-account"
    static let editProfile = baseUrl + "user/editprofile"
    static let mapListing = baseUrl + "user/users-listing"
    static let mapVisibility = baseUrl + "user/on-off-map-visibility"
    static let deleteEvent = baseUrl + "event/delete-event"
    static let chatListing = baseUrl + "support-chat/get-all-chat-user"
    static let createRoom = baseUrl + "support-chat/create-room"
    static let sendMessage = baseUrl + "support-chat/send-message"
    static let allMessage = baseUrl + "support-chat/get-all-message"
    static let updateMessage = baseUrl + "support-chat/update-message"
    static let NotificationList = baseUrl + "notification/notification-listing"
    static let searchListing = baseUrl + "user/search-and-recent-search-listing"
    static let mapListDetail = baseUrl + "user/get-other-profile"
    static let recentSearch = baseUrl + "user/recent-search"
    static let deleteRecent = baseUrl + "user/delete-recent-search"
    static let chatDelete = baseUrl + "support-chat/delete-chat"
    static let blockUser = baseUrl + "user/block-unblock-user"
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


