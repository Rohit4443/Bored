//
//  Singleton.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 07/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit
import CoreTelephony

//import AWSCore
//import AWSS3




class Singleton: NSObject {
 
    static let shared = Singleton()
    static var fromMenuNeedHelp:Bool = false
    static var coins:Int? = 0
//    static var userProfileData:UserProfileData?
    
    var keyboardSize: CGSize = CGSize(width: 0.0, height: 0.0)
    var errorMessageView: ErrorView!
    var callBackFromError: ((Bool?) -> Void)?
    static var isOtherProfile:Bool = false
    static var homeTabController: TabBarVC?
    var is_home_popup_shown: Bool = false
    
    static var msgCount = String()
    static var notifyCount = String()
    
    
    
    func logoutFromDevice() {
//        if AccessToken.current != nil {
//            DispatchQueue.main.async {
//                AccessToken.current = nil
//                Profile.current = nil
//                LoginManager().logOut()
//                print("******** Logout from GIDSignIn *********")
//            }
//        }
//        if LoginManager != "" {
//            print("******** Logout from faceBook *********")
//            LoginManager().logOut()
//        }
        
        OperationQueue.main.cancelAllOperations()
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.accessToken)
        UserDefaults.standard.removeObject(forKey: UserDefaultsCustom.userData)
        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.post(name: .removeAllObservers, object: nil)
        self.gotoLogin()
    }
    
    func getAppEnv()->String {
        #if DEBUG
        return "staging"
        #else
        return "live"
        #endif
    }
//
//    func getAppEnv()->String {
//        #if DEBUG
//        return "live"
//        #else
//        return "staging"
//        #endif
//    }
    
    
    func cancelAllURLRequest() {
        URLSession.shared.getAllTasks { (requestedTaskList: [URLSessionTask]) in
            for task in requestedTaskList {
                task.cancel()
            }
        }
    }
    
    func cancelAllURLRequest(urlString: String) {
        URLSession.shared.getAllTasks { (requestedTaskList: [URLSessionTask]) in
            for task in requestedTaskList {
                if task.originalRequest?.url?.absoluteString.contains(urlString) == true {
                    print("cancel req \(urlString)")
                    task.cancel()
                }
            }
        }
    }
    
    
    
    func canMakePhoneCall(url:URL) -> Bool {
        let mobileNetworkCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode
        let isInvalidNetworkCode = mobileNetworkCode == nil
            || mobileNetworkCode?.count == 0
            || mobileNetworkCode == "65535"
        return UIApplication.shared.canOpenURL(url)
            && !isInvalidNetworkCode
    }
    
    
//    //MARK: ERROR MESSAGE
    func showErrorMessage(error:String, isError:ERROR_TYPE) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            if self.errorMessageView == nil {
                self.errorMessageView = UINib(nibName: NIB_NAME.errorView, bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ErrorView
                self.errorMessageView.delegate = self
                self.errorMessageView.statusIconBgView.isHidden = true
                self.errorMessageView.cornerRadius = 8
                self.errorMessageView.frame = CGRect(x: 10, y: 43, width: SCREEN_SIZE.width-20, height: HEIGHT.errorMessageHeight)
                window.addSubview(self.errorMessageView)
            }
            self.errorMessageView.setErrorMessage(message: error,isError: isError)
        }
    }
    
    func showErrorMessage(pushData: PushModel, isError: ERROR_TYPE, completionHandler:@escaping (_ pushData: Bool?) -> ()) {
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
            if self.errorMessageView == nil {
                self.errorMessageView = UINib(nibName: NIB_NAME.errorView, bundle: nil).instantiate(withOwner: self, options: nil)[0] as? ErrorView
                self.errorMessageView.statusIcon.isHidden = false
                self.errorMessageView.cornerRadius = 8
                self.errorMessageView.statusIcon.image = #imageLiteral(resourceName: "cancel_notes@2x.png")
                self.errorMessageView.statusIcon.cornerRadius = 3
                self.errorMessageView.statusIcon.clipsToBounds = true
                self.errorMessageView.delegate = self
                self.errorMessageView.pushData = pushData
                self.errorMessageView.callBackFromError = { data in
                    completionHandler(data)
                }
                self.errorMessageView.frame = CGRect(x: 10, y: 43 , width: SCREEN_SIZE.width-20, height: HEIGHT.errorMessageHeight)
                window?.addSubview(self.errorMessageView)
            }
            self.errorMessageView.setErrorMessage(message: "\(pushData.title ?? "")\n\(pushData.body ?? "")", isError: isError)
        }
    }
    
    func translateErrorMessage(toBottom:Bool) {
        if errorMessageView != nil {
            if toBottom == true {
                self.errorMessageView.translateToBottom()
            } else {
                self.errorMessageView.translateToTop()
            }
        }
    }
    
//    func gotoSplash() {
//        let splash = UIStoryboard.loginController(identifier: STORYBOARD_ID.loginNavigation) as? UINavigationController
//        var window:UIWindow?
//        if #available(iOS 13, *) {
//            let scene = UIApplication.shared.connectedScenes.first
//            if let windowScene = scene as? UIWindowScene {
//                window = UIWindow(windowScene: windowScene)
////                SceneDelegate.shared?.window = window
//            }
//        } else {
//            if let wind = (UIApplication.shared.delegate as! AppDelegate).window {
//                window = wind
//            } else {
//                window = UIWindow(frame: UIScreen.main.bounds)
//            }
//            window?.frame = UIScreen.main.bounds
//        }
//        window?.rootViewController = splash
//        window?.makeKeyAndVisible()
//    }
    
    func gotoLogin(window win: UIWindow? = nil) {
        var window: UIWindow? = win
        if window == nil {
            window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        }
        let splash = LoginVC()
        let navController = UINavigationController(rootViewController: splash)
        navController.navigationBar.isHidden = true
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func setLoginScreen() {
        var window: UIWindow?
        if window == nil {
            window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        }
        let splash = LoginVC()
        let navController = UINavigationController(rootViewController: splash)
        navController.navigationBar.isHidden = true
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    
    func setHomeScreenView() {
        var window: UIWindow?
        if #available(iOS 13, *) {
            //            let scene = UIApplication.shared.connectedScenes.first
            //            if let windowScene = scene as? UIWindowScene {
            //                window = UIWindow(windowScene: windowScene)
            //            }
//            if SceneDelegate.shared?.window != nil {
//                window = SceneDelegate.shared?.window
//            } else {
                window = UIWindow(frame: UIScreen.main.bounds)
//            }
        } else {
//            if let wind = (UIApplication.shared.delegate as! AppDelegate).window {
//                window = wind
//            } else {
//                window = UIWindow(frame: UIScreen.main.bounds)
//            }
        }
        self.setHomeView(window: window)
    }
    
    
    func setHomeView(window: UIWindow? = UIApplication.shared.windows.first(where: {$0.isKeyWindow})) {
        let homeVC = TabBarVC()
        Singleton.homeTabController = homeVC
        
//        let sideMenu:SWRevealViewController = UIStoryboard.rootController(identifier: "SWRevealViewController") as! SWRevealViewController
//        let menu:MenuController = MenuController()
//        sideMenu.frontViewController = homeVC
//        sideMenu.rearViewController = menu
//        sideMenu.rearViewRevealWidth = SCREEN_SIZE.width-70
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()
        
    }
    
    
//    static func getViewController() -> UIViewController? {
//        if let window = Singleton.window {
//            if let menuController = window.rootViewController as? SWRevealViewController {
//                if let tabCon = menuController.frontViewController as? ESTabBarController {
//                    if let navCon = tabCon.selectedViewController as? UINavigationController {
//                        if let currentCon = navCon.visibleViewController {
//                            print("view controller \(currentCon)")
//                            return currentCon
//                        }
//                    }
//                }
//            }
//        }
//        return nil
//    }
    
    //    static func getTabBarController() -> UITabBarController? {
    //        if let window = Singleton.window {
    //            if let menuController = window.rootViewController as? SWRevealViewController {
    //                if let tabCon = menuController.frontViewController as? UITabBarController {
    //                    return tabCon
    //                }
    //            }
    //        }
    //        return nil
    //    }
    
//    static var calenderStyle: CalendarView.Style {
//        let style = CalendarView.Style()
//
//        style.cellShape            = .round
//        style.cellColorDefault      = UIColor.clear
//        style.cellColorToday       = UIColor.clear
//
//        style.cellSelectedColor    = .blue
//        style.cellSelectedTextColor = .white
//        style.headerTextColor      = UIColor.cloudyBlue
//        style.cellTextColorWeekend  = .cloudyBlue
//        style.cellSelectedBorderColor = .blueBlue
//
//
//        style.cellTextColorDefault     = UIColor.cloudyBlue
//        style.headerBackgroundColor    = UIColor.paleGrey
//        style.weekdaysBackgroundColor  = UIColor.white
//        style.firstWeekday            = .sunday
//        style.locale                 = Locale(identifier: "en_US")
//
//
//        style.headerFont = UIFont.setCustom(.OS_Semibold, 20)
//        style.weekdaysFont = UIFont.setCustom(.OS_Semibold, 16)
//        style.cellFont = UIFont.setCustom(.OS_Semibold, 16)
//
//        style.headerHeight = 100
//        return style
//    }
    
    
    
    
    
    
}

extension Singleton: ErrorDelegate {
    //MARK: ERROR DELEGATE METHOD
    func removeErrorView() {
        if errorMessageView != nil {
            self.errorMessageView.removeFromSuperview()
            self.errorMessageView = nil
        }
    }    
}



//extension Singleton {
//    static func postLikeAction(data: HomeListData? , indexPath: IndexPath?, tableView: UITableView, completion: ((Bool) -> Void)? = nil) {
//
//        guard let postId = data?._id  else {return}
//        guard let indexPath = indexPath else {return}
//
//        let date = Date().toString(format: .full1)
//        let isLiked = data?.is_liked ?? false
//        let json : JSON = [
//            "access_token": UserDefaultsCustom.getAccessToken(),
//            "feed_id": postId,
//            "like": !isLiked,
//            "addedDate": date
//        ]
//
////        print("date is \(date) ******* \(date.utcToLocal)")
//        CreateFeedModel.apiLikeFeed(json: json) { msg in
//            DispatchQueue.main.async {
//                self.showMessage(message: msg ?? "", isError: .success)
//                if data != nil {
//                    data?.is_liked?.toggle()
//                    completion?(data?.is_liked ?? !isLiked)
//                    data?.likes_count = (data?.likes_count ?? 0) + (isLiked ? -1 : 1)
//                }
//                tableView.reload(indexPath: indexPath, animation: .none)
//            }
//
//        }
//
//
//    }
//
//}
