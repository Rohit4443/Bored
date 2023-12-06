//
//  RightTVCell.swift
//  Bored
//
//  Created by Dr.mac on 31/10/23.
//

import UIKit

class RightTVCell: UITableViewCell {

    @IBOutlet weak var rightProfileImage: UIImageView!
    @IBOutlet weak var rightUserNameLabel: UILabel!
    @IBOutlet weak var rightMessageLabel: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var messageBGView: UIView!
    
    
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
            let currentDateString = getDateString(date: currentDate )
            print(currentDateString)
            let previousDateString = getDateString(date: previousDate )
            print(previousDateString)
            if previousDateString == currentDateString {
                labelCurrentTime.isHidden = true
//                stackViewBottomCons.constant = 0
            } else {
                labelCurrentTime.isHidden = false
//                stackViewBottomCons.constant = 14.5
                if Calendar.current.isDateInToday(currentDate) == true {
                    labelCurrentTime.text = "Today"
                }else if Calendar.current.isDateInYesterday(previousDate) == true{
                     labelCurrentTime.text = "Yesterday"
                }
                else{
                    labelCurrentTime.text = getDateString(date: currentDate)
                }
                
            }
            
        }else{
            if let currentDate = currentDate{
               
                labelCurrentTime.isHidden = false
//                stackViewBottomCons.constant = 14.5
                
                if Calendar.current.isDateInToday(currentDate) == true {
                    labelCurrentTime.text = "Today"
                }else if Calendar.current.isDateInYesterday(currentDate) == true{
                    labelCurrentTime.text = "Yesterday"
                }
                else{
                    labelCurrentTime.text = getDateString(date: currentDate)
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
