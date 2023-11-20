//
//  MyEventTVCell.swift
//  Bored
//
//  Created by Dr.mac on 04/11/23.
//

import UIKit

class MyEventTVCell: UITableViewCell {
    
    
    @IBOutlet weak var myEventCollectionView: UICollectionView!
    var controller: UIViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        
    }
    func setCollectionView(){
        myEventCollectionView.delegate = self
        myEventCollectionView.dataSource = self
        myEventCollectionView.register(UINib(nibName: "ProfileEventsCVCell", bundle: nil), forCellWithReuseIdentifier: "ProfileEventsCVCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension MyEventTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileEventsCVCell", for: indexPath) as!
        ProfileEventsCVCell
        cell.profileBgView.isHidden = true
       
        cell.menuButton.isHidden = false
        cell.menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        cell.didSelectBgButton.addTarget(self, action: #selector(didSelectBgButton), for: .touchUpInside)

       
        
        return cell
            }
    
    @objc func menuButtonTapped() {
        let vc = DeleteAccountPopUpVC()
        vc.modalPresentationStyle = .overFullScreen
        controller?.present(vc, true)
    }
        @objc func didSelectBgButton() {
            let vc = MyEventDetailVC()
            controller?.pushViewController(vc, true)
            
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 260)
    }
    
    
   
}
