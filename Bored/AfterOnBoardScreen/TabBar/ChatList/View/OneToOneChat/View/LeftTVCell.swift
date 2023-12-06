//
//  LeftTVCell.swift
//  Bored
//
//  Created by Dr.mac on 31/10/23.
//

import UIKit

class LeftTVCell: UITableViewCell {

    @IBOutlet weak var leftMessageLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var messsageBGView: UIView!
    @IBOutlet weak var imageBottomConst: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDate(currentDate:Date?, previousDate:Date?){
        if let currentDate = currentDate ,
           let previousDate = previousDate
        {
            print("\(currentDate)\(previousDate)")
            let currentDateString = getDateString(date: currentDate)
            let previousDateString = getDateString(date: previousDate)
            if previousDateString == currentDateString {
                currentTimeLbl.isHidden = true
//                 imageBottomConst.constant = 0
            } else {
                currentTimeLbl.isHidden = false
//                imageBottomConst.constant = 30.0
                if Calendar.current.isDateInToday(currentDate) == true {
                    currentTimeLbl.text = "Today"
                }else if Calendar.current.isDateInYesterday(previousDate) == true{
                    currentTimeLbl.text = "Yesterday"
                }
                else{
                    currentTimeLbl.text = getDateString(date: currentDate)
                }
                
            }
            
        }
        else{
            if let currentDate = currentDate {

                currentTimeLbl.isHidden = false
//                imageBottomConst.constant = 30.0
                
                if Calendar.current.isDateInToday(currentDate) == true {
                    currentTimeLbl.text = "Today"
                }else if Calendar.current.isDateInYesterday(currentDate) == true{
                    currentTimeLbl.text = "Yesterday"
                }
                else{
                    currentTimeLbl.text = getDateString(date: currentDate)
                }
//                dateLbl.text = getDateString(date: current)
            }
        }
    }
    
    func getDateString(date:Date)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
        
        
    }
    
}
