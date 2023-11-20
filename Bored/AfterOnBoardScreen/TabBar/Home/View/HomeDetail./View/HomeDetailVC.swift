//
//  HomeDetailVC.swift
//  Bored
//
//  Created by Dr.mac on 26/10/23.
//

import UIKit

class HomeDetailVC: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var homedetailCollectionView: UICollectionView!
    @IBOutlet weak var eventTagsCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var menuButton: UIButton!
    
    //MARK: - Variables -
    var arrayName = ["Baking","Rock Climbing","Pickleball","Baking","Rock Climbing"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        eventTagsCollectionView.collectionViewLayout = createCenterAlignedLayout()
        
    }
    
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        
        homedetailCollectionView.delegate = self
        eventTagsCollectionView.delegate = self
        
        homedetailCollectionView.dataSource = self
        eventTagsCollectionView.dataSource = self
        
        homedetailCollectionView.register(UINib(nibName: "HomeDetailCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeDetailCVCell")
        
        eventTagsCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
        
        pageControl.hidesForSinglePage = true
        self.homedetailCollectionView.isPagingEnabled = true
        menuButton.isHidden = true
        
        
        
    }
    private func createCenterAlignedLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(40), // Variable width
                heightDimension: .absolute(40)  // Fixed height
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0), // 100% width within the section
                heightDimension: .estimated(40)        // Variable height for multiple rows
            ),
            subitems: [item]
        )
        
        group.contentInsets = .init(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        group.interItemSpacing = .fixed(0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    
    //MARK: - IBAction -
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}


//MARK: - CollectionView Delegate and DataSource -
extension HomeDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.homedetailCollectionView {
            return 4
        } else {
            return arrayName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.homedetailCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDetailCVCell", for: indexPath) as! HomeDetailCVCell
            
            
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
            cell.backgroundCellView.borderColor = .clear
            cell.backgroundCellView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            cell.backgroundCellView.cornerRadius = 15
            cell.interestNameButton.setTitle(arrayName[indexPath.row], for: .normal)
            cell.interestNameButton.setTitleColor(UIColor.black, for: .normal)
            
            let fontSize: CGFloat = 12
            let font = UIFont.setCustom(.Poppins_Regular, 12)
            cell.interestNameButton.setAttributedTitle(NSAttributedString(string: cell.interestNameButton.currentTitle!, attributes: [.font: font]), for: .normal)
            let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
            
            cell.backgroundCellView.frame.size = CGSize(width: cell.backgroundCellView.frame.width, height: 19)
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}


//
//        if collectionView == self.homedetailCollectionView {
//            return CGSize(width: collectionView.frame.size.width,height: collectionView.frame.size.height)
//
//        }else{
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
//
//
//            cell.interestNameButton.setTitle(arrayName[indexPath.row], for: .normal)
//
//
//
//            cell.setNeedsLayout()
//            cell.layoutIfNeeded()
//
//
//            let size = cell.contentView.systemLayoutSizeFitting(
//                CGSize(width: collectionView.bounds.width, height: 1)
//            )
//
//
//            let fixedHeight: CGFloat = 40.0
//            let spacing: CGFloat = -2
//            let finalSize = CGSize(width: size.width, height: fixedHeight + spacing)
//
//            return finalSize
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        if collectionView != self.homedetailCollectionView {
//            return -5
//        }
//        return CGFloat()
//    }
//
