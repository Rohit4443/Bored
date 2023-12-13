//
//  ReportTableViewCell.swift
//  Bored
//
//  Created by Dharmani on 13/12/23.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var reportList: ReportData?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func passData(data: ReportData){
        self.reportList = data
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
