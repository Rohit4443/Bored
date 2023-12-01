//
//  TermAndConditionVC.swift
//  Budtender
//
//  Created by apple on 25/08/23.
//

import UIKit
import WebKit
class TermAndConditionVC: UIViewController {
    //-------------------------------------------------------------------------------------------------------
    //MARK: Outlets
    
    @IBOutlet weak var termAndconditionWebView: WKWebView!
    @IBOutlet weak var termAndconditionLabel: UILabel!
    
    var comeFrom:String?
    var link: String?
    //-------------------------------------------------------------------------------------------------------
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        termAndconditionLabel.text = comeFrom
        termAndconditionWebView.load(NSURLRequest(url: NSURL(string: link ?? "")! as URL) as URLRequest)
    }
    //-------------------------------------------------------------------------------------------------------
    //MARK: Action
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
