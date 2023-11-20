//
//  SearchUserTVCell.swift
//  Bored
//
//  Created by Dr.mac on 27/10/23.
//

import UIKit

class SearchUserTVCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var widthConstraintsButton: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
