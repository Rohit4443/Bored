//
//  PalceDetailVC.swift
//  Bored
//
//  Created by Dr.mac on 30/10/23.
//

import UIKit

class PlaceDetailVC: UIViewController {
    @IBOutlet weak var placeDetailCollectionView: UICollectionView!
    
    var arrayName = ["Baking","Cooking","Dance","Swing Dancing","Picnics"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        placeDetailCollectionView.collectionViewLayout = createLeftAlignedLayout()
    }
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        placeDetailCollectionView.delegate = self
        placeDetailCollectionView.dataSource = self
        placeDetailCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
    }
    
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .estimated(40),
              heightDimension: .absolute(37)
            )
          )
          
          let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .estimated(30)
            ),
            subitems: [item]
          )
          group.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 10)
          group.interItemSpacing = .fixed(0)
          
          return UICollectionViewCompositionalLayout(section: .init(group: group))
        }


    @IBAction func menuAction(_ sender: UIButton) {
        let vc = BlockReportPopUpVC()
        vc.controller = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
      
     
    }
    
    @IBAction func backAction(_ sender: Any) {
        popVC()
    }
    
}

//MARK: - CollectionView Delegate and DataSource -
extension PlaceDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        cell.interestNameButton.setTitle(arrayName[indexPath.row], for: .normal);
        cell.backgroundCellView.borderColor = .clear
        cell.backgroundCellView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        cell.backgroundCellView.cornerRadius = 12
       
        cell.interestNameButton.setTitle(arrayName[indexPath.row], for: .normal)
        cell.interestNameButton.setTitleColor(UIColor.black, for: .normal)
        
        let fontSize: CGFloat = 12
        let font = UIFont.setCustom(.Poppins_Regular, 12)
               cell.interestNameButton.setAttributedTitle(NSAttributedString(string: cell.interestNameButton.currentTitle!, attributes: [.font: font]), for: .normal)
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

          
        cell.backgroundCellView.frame.size = CGSize(width: cell.backgroundCellView.frame.width, height: 19)
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

    
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let selectedInterest = arrayName[indexPath.item]
//        
//      
//        
//        if let cell = collectionView.cellForItem(at: indexPath) as? interestCVCell {
//            
//            cell.backgroundCellView.borderColor = .black
//            
//        }
//    }
}
