//
//  MyEventTVCell.swift
//  Bored
//
//  Created by Dr.mac on 04/11/23.
//

import UIKit

protocol MyEventTVCellDelegate{
    func menuAction(eventID: String)
}

class MyEventTVCell: UITableViewCell {
    
    
    @IBOutlet weak var myEventCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    var controller: UIViewController?
    
    var file: [FileData]?
    var eventID:String?
    
    var delegate: MyEventTVCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }
    func setCollectionView(){
        myEventCollectionView.delegate = self
        myEventCollectionView.dataSource = self
        myEventCollectionView.register(UINib(nibName: "ProfileEventsCVCell", bundle: nil), forCellWithReuseIdentifier: "ProfileEventsCVCell")
        pageControl.hidesForSinglePage = true
        self.myEventCollectionView.isPagingEnabled = true
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
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.delegate?.menuAction(eventID: eventID ?? "")
    }
}

extension MyEventTVCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 3
        let k = file?.count ?? 0
        pageControl.numberOfPages = k
        print("\(k)")
        return file?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileEventsCVCell", for: indexPath) as!
        ProfileEventsCVCell
        
        if file?.first?.files == ""{
            cell.eventImage.setImage(image: "eventPlaceholder")
        }else{
            cell.eventImage.setImage(image: file?[indexPath.row].files)
        }
        
        cell.profileBgView.isHidden = true
       
        cell.menuButton.isHidden = true
//        cell.menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        cell.didSelectBgButton.addTarget(self, action: #selector(didSelectBgButton), for: .touchUpInside)

        return cell
            }
 
    @objc func menuButtonTapped() {
        let vc = DeleteAccountPopUpVC()
        vc.eventID = eventID
        vc.modalPresentationStyle = .overFullScreen
        controller?.present(vc, true)
    }
        @objc func didSelectBgButton() {
            let vc = MyEventDetailVC()
            vc.eventID = eventID
            controller?.pushViewController(vc, true)
                
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 260)
    }
    
    
   
}

