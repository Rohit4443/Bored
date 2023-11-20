//
//  FilterVC.swift
//  Bored
//
//  Created by Dr.mac on 27/10/23.
//

import UIKit
import MultiSlider

class FilterVC: UIViewController {

    @IBOutlet weak var slider: MultiSlider!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    var arrayName = ["Baking","Cooking","Dance","Swing Dancing","Picnics","Hiking","Rock Climbing","Pickleball","Plants","Yoga","Museums","Video Game","Fitness","BBQ","Singing","Festivals","Sports","Camping","Concerts","Trivia",]
    
  //  var completion : (() -> Void)? = nil
    var arraySelectedValue:[String] = []
  //  var selectedInterest: String?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionViewDelegates()
        slider.valueLabelPosition = .left
        slider.valueLabelPosition = .top
        slider.isValueLabelRelative = true
        slider.valueLabelColor = .black
        filterCollectionView.collectionViewLayout = createCenterAlignedLayout()
        
    }
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
    }

    
    private func createCenterAlignedLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(40), // Variable width
                heightDimension: .absolute(50)  // Fixed height
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0), // 100% width within the section
                heightDimension: .estimated(50)        // Variable height for multiple rows
            ),
            subitems: [item]
        )
        
        group.contentInsets = .init(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        group.interItemSpacing = .fixed(5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}


//MARK: - CollectionView Delegate and DataSource -
extension FilterVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        cell.interestNameButton.setTitle(arrayName[indexPath.row], for: .normal);        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //            return CGSize(width: arrayName[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]).width + 55, height: 51)
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedInterest = arrayName[indexPath.item]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? interestCVCell {
            
            if arraySelectedValue.contains(selectedInterest) {
                arraySelectedValue.removeAll { $0 == selectedInterest }
            } else {
                arraySelectedValue.append(selectedInterest)
            }
            
            let isSelected = arraySelectedValue.contains(selectedInterest)
            cell.backgroundCellView.borderColor = isSelected ? .black : .systemGray
            cell.interestNameButton.setTitleColor(isSelected ? .black : .systemGray, for: .normal)
            
        }
    }
    
}
