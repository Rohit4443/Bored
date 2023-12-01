//
//  SettingsTVCell.swift
//  Bored
//
//  Created by Dr.mac on 31/10/23.
//

import UIKit

protocol SettingsTVCellDelegate{
    func toggleSwitch(switch:UISwitch)
}

class SettingsTVCell: UITableViewCell {

    @IBOutlet weak var settingsIconImage: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var switchToggleButton: UISwitch!
    @IBOutlet weak var nextForwardButton: UIButton!
    
    var delegate: SettingsTVCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggleSwitchAction(_ sender: UISwitch) {
        self.delegate?.toggleSwitch(switch: sender)
    }
}


