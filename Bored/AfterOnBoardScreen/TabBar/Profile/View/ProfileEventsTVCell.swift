//
//  ProfileEventsTVCell.swift
//  Bored
//
//  Created by Dr.mac on 02/11/23.
//

import UIKit

class ProfileEventsTVCell: UITableViewCell {

    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        
    }
    func setCollectionView(){
        self.profileCollectionView.delegate = self
        self.profileCollectionView.dataSource = self
        self.profileCollectionView.register(UINib(nibName: "ProfileEventsCVCell", bundle: nil), forCellWithReuseIdentifier: "ProfileEventsCVCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
extension ProfileEventsTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileEventsCVCell", for: indexPath) as! ProfileEventsCVCell
        
        cell.menuButton.isHidden = true
       
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 260)
    }
    
}
