//
//  BlockedUserTVCell.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class BlockedUserTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
