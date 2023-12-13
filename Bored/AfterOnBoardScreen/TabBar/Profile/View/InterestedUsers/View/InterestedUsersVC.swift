//
//  InterestedUsersVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit
import IQKeyboardManagerSwift

class InterestedUsersVC: UIViewController {
    
    @IBOutlet weak var interestedUsersTableView: UITableView!
    
    var arrayListing: [InterestedUsersData]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        configureKeboard()
    }
    
    func setTableViewDelegates(){
        interestedUsersTableView.delegate = self
        interestedUsersTableView.dataSource = self
        interestedUsersTableView.register(UINib(nibName: "SearchUserTVCell", bundle: nil), forCellReuseIdentifier: "SearchUserTVCell")
        self.navigationController?.navigationBar.isHidden = true
        
    }
    func configureKeboard() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //        IQKeyboardManager.shared.toolbarTintColor = SSColor.appBlack
        IQKeyboardManager.shared.enableAutoToolbar = true
        //        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailsVC.self, ChatViewController.self]
        IQKeyboardManager.shared.resignFirstResponder()
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIScrollView.self,UIView.self,UITextField.self,UITextView.self,UIStackView.self]
        
    }
    
    
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    
}


extension InterestedUsersVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //            return 5
        return arrayListing?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTVCell", for: indexPath) as! SearchUserTVCell
        cell.deleteButton.isHidden = true
        cell.widthConstraintsButton.constant = 0
        cell.profileImage.setImage(image: arrayListing?[indexPath.row].image,placeholder: UIImage(named: "eventPlaceholder"))
        cell.nameLabel.text = arrayListing?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

