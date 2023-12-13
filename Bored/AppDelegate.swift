//
//  AppDelegate.swift
//  Bored
//
//  Created by Dr.mac on 20/10/23.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//         let splash = SelectLoginSignUpVC()
//        let navController = UINavigationController(rootViewController: splash)
        sleep(2)
//        navController.navigationBar.isHidden = true
        
        window = UIWindow(frame:UIScreen.main.bounds)
        application.applicationIconBadgeNumber = 0
//        IQKeyboardManager.shared().isEnabled = true
        configureKeboard()
        GMSPlacesClient.provideAPIKey("AIzaSyAiNW0f-BGzXhmOaNhU2st9VXvfRDg-zSA")
//        self.setNotification(application)
        let accesstoken = UserDefaultsCustom.getUserData()
        if accesstoken?.access_token?.count ?? 0 > 0 {
            Singleton.shared.setHomeView(window: self.window)
        } else {
            Singleton.shared.gotoLogin(window: self.window)
        }
      
        return true
    }
    
    private func configureKeboard() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //        IQKeyboardManager.shared.toolbarTintColor = SSColor.appBlack
        IQKeyboardManager.shared.enableAutoToolbar = true
        //        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailsVC.self, ChatViewController.self]
        IQKeyboardManager.shared.resignFirstResponder()
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIScrollView.self,UIView.self,UITextField.self,UITextView.self,UIStackView.self]
        
    }

    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
        debugPrint("device token is \(deviceTokenString)")
        AppDefaults.deviceToken = deviceTokenString
//        UserDefaults.standard.set(deviceTokenString, forKey: DefaultKeys.deviceToken)
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

