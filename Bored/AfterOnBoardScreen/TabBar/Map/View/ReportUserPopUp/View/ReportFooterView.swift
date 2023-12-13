//
//  ReportFooterView.swift
//  Bored
//
//  Created by Dharmani on 13/12/23.
//

import UIKit
import GrowingTextView

protocol ReportFooterViewDelegate{
    func submitAction()
    func otherText(text: String)
}

class ReportFooterView: UIView {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var otherTV: GrowingTextView!
    
    
    var delegate: ReportFooterViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        otherTV.delegate = self
        // Initialization code
       
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        self.delegate?.submitAction()
    }
    
}
extension ReportFooterView: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text
        print(text)
        self.delegate?.otherText(text: text ?? "")
    }
}
