//
//  MapCVCell.swift
//  Bored
//
//  Created by Dr.mac on 27/10/23.
//

import UIKit

class MapCVCell: UICollectionViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userAge: UILabel!
    @IBOutlet weak var interestCollectionView: UICollectionView!
    
    var interestArray: [InterestsDatum]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        // Initialization code
    }
    
    func setCollectionView(){
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        interestCollectionView.register(UINib(nibName: "interestCVCell"), forCellWithReuseIdentifier: "interestCVCell")
    }
    

}
extension MapCVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        cell.interestNameButton.setTitle(interestArray?[indexPath.row].interest_name, for: .normal)
        cell.interestNameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)

        cell.backgroundCellView.backgroundColor = #colorLiteral(red: 0.9647058845, green: 0.9647058845, blue: 0.9647058845, alpha: 1)
        cell.backgroundCellView.setBorder(.white, corner: 15, 0)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = interestArray?[indexPath.row].interest_name ?? ""
        let width = UILabel.textWidth(font: UIFont.setCustom(.Poppins_Regular, 6), text: text)
        return CGSize(width: (width + 60) , height: collectionView.frame.size.height)
    }
}
