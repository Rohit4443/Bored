//
//  SettingsTVCell.swift
//  Bored
//
//  Created by Dr.mac on 31/10/23.
//

import UIKit

class SettingsTVCell: UITableViewCell {

    @IBOutlet weak var settingsIconImage: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var switchToggleButton: UISwitch!
    @IBOutlet weak var nextForwardButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       
            
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


