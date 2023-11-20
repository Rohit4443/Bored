//
//  UploadImagesCVCell.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit

class UploadImagesCVCell: UICollectionViewCell {

    @IBOutlet weak var deletePhotoButton: UIButton!
    @IBOutlet weak var addPhotoImage: UIImageView!
    var deleteButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure the cell
        deletePhotoButton.isHidden = true
        deletePhotoButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc func deleteButtonTapped() {
        // Handle the delete button action
        deleteButtonAction?()
    }
}
