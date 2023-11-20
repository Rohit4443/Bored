//
//  NotificationTVCell.swift
//  Bored
//
//  Created by Dr.mac on 26/10/23.
//

import UIKit

class NotificationTVCell: UITableViewCell {
    @IBOutlet weak var userNotificationImage: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
