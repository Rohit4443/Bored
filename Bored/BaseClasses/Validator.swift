//
//  Validator.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 03/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit


class Validator {
    
    
    static public func validateEmail(candidate: String) -> (Bool,String) {
        guard candidate.count > 0  else {
            return (false, "Please enter email")
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let isValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        return (isValid, "Please enter valid email")
    }
    
    static public func validateAccountId(id:String) -> Bool {
        let regex = "^[a-z-A-Z]{6}+[0-9]{2}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id)
    }
    
    static public func validateUserName(userName: String, message: String) -> (Bool,String) {
        
        guard userName.count > 0 else {
            return (false, "Please enter Project Name")
        }
        
        guard userName.count <= 30 else {
            return (false, "Name contain only 30 words.")
        }
        
        let emailRegex = "(?=.*[a-z]).{1,}"//"[A-Za-z0-9]"//, "(?=.*[A-Z])(?=.*[a-z]).{8,}
        let isValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: userName)
        return (isValid, "Usernames must include at least one of which must be a letter.")
    }
    
    static public func validateName(name: String, message: String) -> (Bool,String) {
        guard name.count > 0  else {
            return (false, message)
        }
        return (true, message)
    }
    static public func validateSeries(name: String, message: String) -> (Bool,String) {
        guard name.count > 0  else {
            return (false, message)
        }
        return (true, message)
    }
    
    static public func validate_is_select(is_select: Bool, message: String) -> (Bool,String) {
        guard is_select == true  else {
            return (false, message)
        }
        return (true, message)
    }
    
    static public func validateCaption(caption: String,message: String) -> (Bool,String) {
        guard caption.count > 0  else {
            return (false, message)
        }
        return (true, message)
    }
    
    static public func validateDescription(words: String?) -> (Bool,String) {
        guard let desc = words, desc.count > 0  else {
            return (false,"Please enter description")
        }
        
        guard desc.count <= 650 else {
            return (false,"Description has only 500 words")
        }
        
        return (true,"")
    }
    
    static public func validateTimelineDescription(words: String?) -> (Bool,String) {
        guard let desc = words, desc.count > 0  else {
            return (false,"Please enter description")
        }
        
        guard desc.count <= 300 else {
            return (false,"Description has only 300 words")
        }
        
        return (true,"")
    }
    
    static public func validatePhoneNumber(number: String?) -> (Bool,String) {
        guard let phone = number, phone.count > 0  else {
            return (false,"Please enter phone number")
        }
        
        guard phone.count > 8 && phone.count < 16 else {
            return (false,"Please enter valid phone number")
        }
        
        return (true,"")
    }
    
    static public func validateIdNumber(number: String?) -> (Bool,String) {
        guard let phone = number, phone.count > 0  else {
            return (false,"Please enter id number")
        }
        
        guard phone.count > 0 && phone.count < 14 else {
            return (false,"Please enter valid id number")
        }
        
        return (true,"")
    }
    
    static public func validatePassword(password:String?, val:String = "") -> (Bool,String) {
        guard let pwd = password, pwd.count > 0 else {
            return (false,"Please enter your \(val)password")
        }
        guard pwd.count >= 6 else {
            return (false, "\(val)Password should be 6 characters long")
        }
        return (true,"Please enter valid \(val)password")
    }
    
    static public func validateOldPassword(password:String?, val:String = "") -> (Bool,String) {
        guard let pwd = password, pwd.count > 0 else {
            return (false,"Please enter your \(val)current password")
        }
        guard pwd.count >= 6 else {
            return (false, "\(val)Password should be 6 characters long")
        }
        return (true,"Please enter valid \(val)password")
    }
    
    static public func validateNewPassword(password:String?, val:String = "") -> (Bool,String) {
        guard let pwd = password, pwd.count > 0 else {
            return (false,"Please enter your \(val)new password")
        }
        guard pwd.count >= 6 else {
            return (false, "\(val)Password should be 6 characters long")
        }
        return (true,"Please enter valid \(val)password")
    }
    
    static public func validateReEnterPassword(password:String?, val:String = "") -> (Bool,String) {
        guard let pwd = password, pwd.count > 0 else {
            return (false,"Please enter your  confirm new Password")
        }
        guard pwd.count >= 6 else {
            return (false, "\(val)Password should be 6 characters long")
        }
        return (true,"Please enter valid \(val)password")
    }
    static public func validateConfirmPassword(password:String?, val:String = "") -> (Bool,String) {
        guard let pwd = password, pwd.count > 0 else {
            return (false,"Please enter your confirm password")
        }
        guard pwd.count >= 6 else {
            return (false, "\(val)Password should be 6 characters long")
        }
        return (true,"Please enter valid \(val)password")
    }
    
    static public func validatePrice(number: String?) -> (Bool,String) {
        guard let price = number, price.count > 0  else {
            return (false,"Please enter price")
        }
        
        guard price.count <= 10 else {
            return (false,"Price should be 10 characters long ")
        }
        
        return (true,"")
    }
    
    static public func validateTitle(userName: String, message: String) -> (Bool,String) {
        
        guard userName.count > 0 else {
            return (false, "Please enter title")
        }
        
        guard userName.count <= 25 else {
            return (false, "Title contain only 25 words.")
        }
        return (true,"")
        
    }
    static public func validatePostal(userName: String, message: String) -> (Bool,String) {
        
        guard userName.count > 0 else {
            return (false, "Please enter Postal Code")
        }
        
        guard userName.count < 7 else {
            return (false, "Postal Code contain only 6 numbers.")
        }
        return (true,"")
        
    }
    
    static public func validateCollectionView(collectionView: UICollectionView?) -> (Bool, String) {
        guard let collectionView = collectionView else {
            return (false, "Interest is nil")
        }
        
        guard let dataSource = collectionView.dataSource else {
            return (false, "Interest must contain items")
        }
        
        guard dataSource.collectionView(collectionView, numberOfItemsInSection: 0) > 0 else {
            return (false, "Interest is empty")
        }
        
        return (true, "")
    }
 
    static public func validateButtonSelection(buttons: [UIButton]) -> (Bool, String) {
        guard buttons.contains(where: { $0.isSelected }) else {
            return (false, "Please select a button")
        }

        return (true, "")
    }

    
    
}
