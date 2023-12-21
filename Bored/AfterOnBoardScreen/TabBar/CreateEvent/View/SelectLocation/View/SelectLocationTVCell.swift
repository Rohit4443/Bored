//
//  SelectLocationTVCell.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit
protocol SelectLocationTVCellDelegate{
    func deleteAction(cell: SelectLocationTVCell)
}

class SelectLocationTVCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var locationImage: UIImageView!
    
    var delegate: SelectLocationTVCellDelegate?
    var searchLocation: RecentSearchLocationData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func passData(data:RecentSearchLocationData){
        self.searchLocation = data
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.delegate?.deleteAction(cell: self)
    }
}
