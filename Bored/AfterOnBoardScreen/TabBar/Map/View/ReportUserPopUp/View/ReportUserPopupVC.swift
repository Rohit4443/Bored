//
//  ReportUserPopupVC.swift
//  Bored
//
//  Created by apple on 02/11/23.
//

import UIKit
import GrowingTextView

class ReportUserPopupVC: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var textViewBGView: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissPopUpOnViewTap()
    }
 
    func dismissPopUpOnViewTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapgesture))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapgesture(){
       dismiss(animated: true)
    }
    
    @IBAction func selectOptionAction(_ sender: UIButton) {
        if sender.tag == 0{
            option1Button.isSelected = true
            option2Button.isSelected = false
            option3Button.isSelected = false
            option4Button.isSelected = false
            textViewBGView.isHidden = true
            option4Button.setImage(UIImage(named: "ic_unSelect"), for: .normal)


        }else if sender.tag == 1{
            option2Button.isSelected = true
            option1Button.isSelected = false
            option3Button.isSelected = false
            option4Button.isSelected = false
            textViewBGView.isHidden = true
            option4Button.setImage(UIImage(named: "ic_unSelect"), for: .normal)


        }else if sender.tag == 2{
            option3Button.isSelected = true
            option1Button.isSelected = false
            option2Button.isSelected = false
            option4Button.isSelected = false
            textViewBGView.isHidden = true
            option4Button.setImage(UIImage(named: "ic_unSelect"), for: .normal)


        }else{
            textViewBGView.isHidden = false
            //option4Button.isSelected = !option4Button.isSelected
            option1Button.isSelected = false
            option2Button.isSelected = false
            option3Button.isSelected = false
            option4Button.setImage(UIImage(named: "ic_select"), for: .normal)

            
        }
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

