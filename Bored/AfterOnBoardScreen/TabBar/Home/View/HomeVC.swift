//
//  HomeVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var findInterestCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
   
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        
    }
   
    func setCollectionViewDelegates(){
        findInterestCollectionView.delegate = self
        findInterestCollectionView.dataSource = self
        findInterestCollectionView.register(UINib(nibName: "HomeFindInterestCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeFindInterestCVCell")
        pageControl.hidesForSinglePage = true
        self.findInterestCollectionView.isPagingEnabled = true
        
        
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
    @IBAction func notificationAction(_ sender: UIButton) {
        let vc = NotificationVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc , true)
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = FilterVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc , true)
    }
    
    //        let vc = ReportUserPopUpVC()
    //        vc.modalPresentationStyle = .overFullScreen
    //        self.navigationController?.present(vc, true)
    
    
}

//MARK: - CollectionView Delegate and DataSource -
extension HomeVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFindInterestCVCell", for: indexPath) as! HomeFindInterestCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width,height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = HomeDetailVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
}

