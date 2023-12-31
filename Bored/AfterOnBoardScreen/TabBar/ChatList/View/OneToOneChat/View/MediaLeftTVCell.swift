//
//  MediaLeftTVCell.swift
//  Bored
//
//  Created by Dr.mac on 31/10/23.
//

import UIKit

class MediaLeftTVCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
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
                dateLabel.isHidden = true
//                stackViewBottomCons.constant = 0
            } else {
                dateLabel.isHidden = false
//                stackViewBottomCons.constant = 14.5
                if Calendar.current.isDateInToday(currentDate) == true {
                    dateLabel.text = "Today"
                }else if Calendar.current.isDateInYesterday(previousDate) == true{
                    dateLabel.text = "Yesterday"
                }
                else{
                    dateLabel.text = getDateString(date: currentDate)
                }
                
            }
            
        }else{
            if let currentDate = currentDate{
               
                dateLabel.isHidden = false
//                stackViewBottomCons.constant = 14.5
                
                if Calendar.current.isDateInToday(currentDate) == true {
                    dateLabel.text = "Today"
                }else if Calendar.current.isDateInYesterday(currentDate) == true{
                    dateLabel.text = "Yesterday"
                }
                else{
                    dateLabel.text = getDateString(date: currentDate)
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
