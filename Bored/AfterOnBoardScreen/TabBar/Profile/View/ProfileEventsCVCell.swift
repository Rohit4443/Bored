//
//  ProfileEventsCVCell.swift
//  Bored
//
//  Created by apple on 02/11/23.
//

import UIKit

class ProfileEventsCVCell: UICollectionViewCell {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var profileBgView: UIView!
    @IBOutlet weak var nameBgView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var didSelectBgButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

}
