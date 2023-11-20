//
//  InterestEventTags.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit

class InterestEventTags: UIViewController {
    @IBOutlet weak var showInterestCollectionView: UICollectionView!
    
    @IBOutlet weak var collheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherBgView: UIView!
    @IBOutlet weak var otherViewHeightConstraint: NSLayoutConstraint!
    var arrayName = ["Baking","Cooking","Dance","Swing Dancing","Picnics","Hiking","Rock Climbing","Pickleball","Plants","Yoga","Museums","Video Game","Fitness","BBQ","Singing","Festivals","Sports","Camping","Concerts","Trivia",]
    var completion : (() -> Void)? = nil
    var arraySelectedValue:[String] = []
    var selectedInterest: String?
    var comefrom: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        showInterestCollectionView.collectionViewLayout = createCenterAlignedLayout()
        collheightConstraint.constant = CGFloat(50*arrayName.count)

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if comefrom == "eventTags"{
            otherBgView.isHidden = true
            otherViewHeightConstraint.constant = 0

        }else{

        }
    }
    
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        showInterestCollectionView.delegate = self
        showInterestCollectionView.dataSource = self
        showInterestCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
        
        
    }
   
    
    private func createCenterAlignedLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(40),
                heightDimension: .absolute(50)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(50)
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
            top: 10,
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
extension InterestEventTags : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        cell.interestNameButton.setTitle(arrayName[indexPath.row], for: .normal);        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
