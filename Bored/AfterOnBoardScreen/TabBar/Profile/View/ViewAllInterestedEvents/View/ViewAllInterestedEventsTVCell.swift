//
//  ViewAllInterestedEventsTVCell.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class ViewAllInterestedEventsTVCell: UITableViewCell {

    @IBOutlet weak var viewInterestedEventsCollectionview: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var viewModel: InterestedScreenVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        
    }
    
    func setViewModel(){
        self.viewModel = InterestedScreenVM(observer: self)
        self.viewModel?.interestListingApi()
    }
    
    func setCollectionView(){
        self.viewInterestedEventsCollectionview.delegate = self
        self.viewInterestedEventsCollectionview.dataSource = self
        self.viewInterestedEventsCollectionview.register(UINib(nibName: "ProfileEventsCVCell", bundle: nil), forCellWithReuseIdentifier: "ProfileEventsCVCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
extension ViewAllInterestedEventsTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
        return viewModel?.interestedData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileEventsCVCell", for: indexPath) as! ProfileEventsCVCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 260)
    }
    
}
extension ViewAllInterestedEventsTVCell: InterestedScreenVMObserver{
    func observerInterestListing() {
        viewInterestedEventsCollectionview.reloadData()
    }

    
}
