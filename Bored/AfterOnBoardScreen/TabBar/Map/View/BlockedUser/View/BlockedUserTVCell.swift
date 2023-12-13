//
//  BlockedUserTVCell.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit
protocol BlockedUserTVCellDelegate{
    func unblockAction(cell: BlockedUserTVCell)
}

class BlockedUserTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var delegate: BlockedUserTVCellDelegate?
    var blockUserData: BlockData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func passData(data:BlockData){
        self.blockUserData = data
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func unblockAction(_ sender: UIButton) {
        self.delegate?.unblockAction(cell: self)
    }
}
