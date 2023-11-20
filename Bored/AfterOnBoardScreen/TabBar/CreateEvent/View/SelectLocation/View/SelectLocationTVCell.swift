//
//  SelectLocationTVCell.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit

class SelectLocationTVCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var locationImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
