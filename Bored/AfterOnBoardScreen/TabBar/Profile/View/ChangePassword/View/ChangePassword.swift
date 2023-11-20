//
//  ChangePassword.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit

class ChangePassword: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reEnterPassword: UITextField!
    
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //MARK: - IBAction -
    @IBAction func updatePassword(_ sender: UIButton) {
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}
