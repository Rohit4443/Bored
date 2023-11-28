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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLAbel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var viewModel: InterestedScreenVM?
    var date: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        setViewModel()
        
    }
    
    func setViewModel(){
        self.viewModel = InterestedScreenVM(observer: self)
        self.viewModel?.interestListingApi()
    }
    
    func setCollectionView(){
        self.profileCollectionView.delegate = self
        self.profileCollectionView.dataSource = self
        self.profileCollectionView.register(UINib(nibName: "ProfileEventsCVCell", bundle: nil), forCellWithReuseIdentifier: "ProfileEventsCVCell")
        
        pageControl.hidesForSinglePage = true
        self.profileCollectionView.isPagingEnabled = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
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
    
}
extension ProfileEventsTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
        if let events = viewModel?.interestedData, events.indices.contains(section) {
            let k = events[section].files?.count ?? 0
            pageControl.numberOfPages = k
            print(events[section].files?.count)
            return events[section].files?.count ?? 0
        }
  
        return 0
        
    }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileEventsCVCell", for: indexPath) as! ProfileEventsCVCell
                if let events = viewModel?.interestedData, events.indices.contains(indexPath.section),
                   let files = events[indexPath.section].files, files.indices.contains(indexPath.item) {
                    cell.eventImage.setImage(image: files[indexPath.item].files ?? "",placeholder: UIImage(named: "eventPlaceholder"))
                    
                    //                if let fileURL = URL(string: files[indexPath.item].files ?? "") {
                    //
                    //                }
                }
            
            cell.menuButton.isHidden = true
            
            return cell
            
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width, height: 260)
        }
        
    }
    extension ProfileEventsTVCell: InterestedScreenVMObserver{
        func observerInterestListing() {
            profileCollectionView.reloadData()
            
        }
        
        
    }
