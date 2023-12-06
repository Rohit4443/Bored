//
//  MediaRightTVCell.swift
//  Bored
//
//  Created by Dharmani on 05/12/23.
//

import UIKit

class MediaRightTVCell: UITableViewCell {
    @IBOutlet weak var dateLAbel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNAmeLabel: UILabel!
    @IBOutlet weak var imageMessage: UIImageView!
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
                dateLAbel.isHidden = true
//                stackViewBottomCons.constant = 0
            } else {
                dateLAbel.isHidden = false
//                stackViewBottomCons.constant = 14.5
                if Calendar.current.isDateInToday(currentDate) == true {
                    dateLAbel.text = "Today"
                }else if Calendar.current.isDateInYesterday(previousDate) == true{
                    dateLAbel.text = "Yesterday"
                }
                else{
                    dateLAbel.text = getDateString(date: currentDate)
                }
                
            }
            
        }else{
            if let currentDate = currentDate{
               
                dateLAbel.isHidden = false
//                stackViewBottomCons.constant = 14.5
                
                if Calendar.current.isDateInToday(currentDate) == true {
                    dateLAbel.text = "Today"
                }else if Calendar.current.isDateInYesterday(currentDate) == true{
                    dateLAbel.text = "Yesterday"
                }
                else{
                    dateLAbel.text = getDateString(date: currentDate)
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
