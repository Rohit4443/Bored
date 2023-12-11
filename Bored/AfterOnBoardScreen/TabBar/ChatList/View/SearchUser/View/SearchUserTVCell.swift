//
//  SearchUserTVCell.swift
//  Bored
//
//  Created by Dr.mac on 27/10/23.
//

import UIKit
protocol SearchUserTVCellDelegate{
    func deleteAction(cell: SearchUserTVCell)
}

class SearchUserTVCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var widthConstraintsButton: NSLayoutConstraint!
    
    var delegate: SearchUserTVCellDelegate?
    var searchData: RecentSearchData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func passData(data:RecentSearchData){
        self.searchData = data
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func DeleteAction(_ sender: UIButton) {
        self.delegate?.deleteAction(cell: self)
    }
}
