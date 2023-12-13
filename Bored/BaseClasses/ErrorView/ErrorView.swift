//
//  ErrorView.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 30/03/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.//

import UIKit

enum ERROR_TYPE {
    case error
    case success
    case message
    case notification
}


protocol ErrorDelegate {
    func removeErrorView()
}
typealias JSON = [String:Any]

class ErrorView: UIView {
    
    @IBOutlet var statusIcon: UIImageView!
    @IBOutlet var statusIconBgView: UIView!
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var effectView: UIVisualEffectView!
    
    
    var delegate: ErrorDelegate!
    var callBackFromError: ((Bool?) -> Void)?
    var pushData: PushModel?
    
    
    override func awakeFromNib() {
        errorMessage.textColor = UIColor.themeConstrast
        errorMessage.font = UIFont.systemFont(ofSize: 14)
        errorMessage.numberOfLines = 0
//        setCustom(.latoRegular, 14)
        
        self.statusIcon.image = #imageLiteral(resourceName: "ic_BoredImage").withRenderingMode(.alwaysTemplate)
        self.statusIcon.tintColor = UIColor.white
        statusIcon.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideErrorMessageWithTap))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    func setErrorMessage(message: String, isError: ERROR_TYPE) {
        self.effectView.isHidden = true
        var label_width: CGFloat = SCREEN_SIZE.width - 50
        switch isError {
        case .error:
            self.backgroundColor = UIColor.errorColor
        case .success:
            self.backgroundColor = UIColor.successColor
        case .message:
            self.backgroundColor = UIColor.messageColor
        case .notification:
            self.effectView.isHidden = false
            self.backgroundColor = .clear
            self.errorMessage.textColor = .white
            self.statusIcon.image = #imageLiteral(resourceName: "ic_BoredImage").withRenderingMode(.alwaysOriginal)
            label_width = SCREEN_SIZE.width - 90
        }
//        self.errorMessage.text = message
//        var height = message.heightWithConstrainedWidth(width: label_width, font: UIFont.systemFont(ofSize: 14)).height
//        if isError == .notification && height < 25 {
//            height = 25
//        }
//        if height > 14 {
//            self.frame.size.height = (HEIGHT.errorMessageHeight - 13) + (height)
//        //    + size.height
//            //+ UIApplication.shared.statusBarFrame.height
//            self.frame.origin.y = -self.frame.height
//        }
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        self.showErrorMessage(message: message)
        
        self.errorMessage.text = message
        let size = message.heightWithConstrainedWidth(width: SCREEN_SIZE.width-57, font: UIFont.systemFont(ofSize: 14))
        if size.height > 14 {
            self.frame.size.height = (HEIGHT.errorMessageHeight) + size.height
//                + UIApplication.shared.statusBarFrame.height
            self.frame.origin.y = -self.frame.height
        }
        self.showErrorMessage()
    }
    
    
    func showErrorMessage() {
        var height:CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow == true})
            height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            height = UIApplication.shared.statusBarFrame.height
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: .beginFromCurrentState) {
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height + height)
        } completion: { finished in
            self.perform(#selector(self.hideErrorMessageWithoutTap), with: nil, afterDelay: 3.0)
        }
    }
    
    func showErrorMessage(message:String) {
        let height = UIApplication.shared.statusBarFrame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height + height)
        }, completion: { finished in
            self.perform(#selector(self.hideErrorMessageWithoutTap), with: nil, afterDelay: 3.0)
        })
    }
    
    @objc func hideErrorMessageWithTap() {
        if self.pushData != nil {
            self.callBackFromError?(true)
        }
        self.hideErrorMessageWithoutTap()
    }
    
    @objc func hideErrorMessageWithoutTap() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { finished in
            self.delegate.removeErrorView()
        })
    }
    
    func translateToBottom() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -(self.frame.height))
        }, completion: { finished in
//             self.delegate.removeErrorView()
        })
    }
    
    func translateToTop() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -(self.frame.height + Singleton.shared.keyboardSize.height))
        }, completion: { finished in
//            self.perform(#selector(self.hideErrorMessage), with: nil, afterDelay: 3.0)
        })
    }
    
}
class PushModel: NSObject {
    var type: PUSH_TYPE?
    var title: String?
    var post_id: String?
    var user_id: String?
    
    var data :[String:Any]?
    var alert:[String:Any]?
    var body:String?
    var creation_date: String?
    var followID: String?
    
    var notification_id: String?
    var notification_read_status: String?
    var chatId: String?
    var blogId: String?
    var postId: String?
    var name: String?
    var roomId: String?
    var otherUserId: String?
    var seen: String?
    var message: String?
    var badge: String?
    var desmessage: String?
    var userName:String?
    var topTitle:String?
    
    
    
    var actionById: String?
    var disable: String?
    var status_id: String?
    var sound: String?
    var json: [String:Any]!
}

//extension PushModel {
//    
//    convenience init(json: [String: Any]) {
//        self.init()
//        self.json = json
//        
//        if let aps = json["aps"] as? JSON {
//            let satus = aps["Status"] as? String ?? ""
//            print("satus :- \(satus)")
//            if let alert = aps["alert"] as? [String:Any] {
//                self.alert = alert
//                self.body = alert["body"] as? String ?? ""
//                self.title = alert["title"] as? String ?? ""
//                print("body :- \(body) title \(title)")
//            }
//            self.badge = aps["badge"] as? String ?? ""
//            if let data = aps["data"] as? [String: Any]  {
//                self.data = data
//                self.creation_date = data["created"] as? String ?? ""
//                self.followID = data["actionId"] as? String ?? ""
//                self.message = data["description"] as? String ?? ""
//                self.notification_id = data["notificationId"] as? String ?? ""
//                self.notification_read_status = data["seen"] as? String ?? ""
//                self.actionById =  data["actionById"] as? String ?? ""
//                self.disable = data["disable"] as? String ?? ""
//                self.user_id = data["userId"] as? String ?? ""
//                
//                self.blogId = data["blogId"] as? String ?? ""
//                self.chatId = data["chatId"] as? String ?? ""
//                self.desmessage = data["message"] as? String ?? ""
//                self.name = data["name"] as? String ?? ""
//                self.otherUserId = data["otherUserId"] as? String ?? ""
//                self.postId = data["postId"] as? String ?? ""
//                self.roomId = data["roomId"] as? String ?? ""
//                self.seen = data["seen"] as? String ?? ""
//                self.userName = data["userName"] as? String ?? ""
//                self.topTitle = data["title"] as? String ?? ""
//                print("self.otherUserId \(self.otherUserId)")
//                
//                
//                if let notification_type = data["type"] as? Int {
//                    self.type = PUSH_TYPE(rawValue: notification_type)
//                } else if let notification_type = (data["type"] as? String)?.toInt {
//                    self.type = PUSH_TYPE(rawValue: notification_type)
//                }
//            
//            }
//            let sound = aps["sound"] as? String ?? ""
//            self.sound = sound
//        }
//    }
//    
//}
enum PUSH_TYPE: Int {
    case following        = 0
    case admire           = 1
    case postLike         = 2
    case postComment      = 3
    case postCommentLike  = 4
    case BlogLike         = 5
    case blogComment       = 6
    case blogCommentLike  = 7
    case sendPost  = 8
    case message      = 9
    
}
