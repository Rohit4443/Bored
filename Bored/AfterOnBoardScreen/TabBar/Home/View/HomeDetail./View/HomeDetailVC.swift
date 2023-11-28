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
    @IBOutlet weak var locationLAbel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var startEndLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var interestedBtn: UIButton!
    @IBOutlet weak var notInterestedBtn: UIButton!
    
    //MARK: - Variables -
    var arrayName = ["Baking","Rock Climbing","Pickleball","Baking","Rock Climbing"]
    var viewModel: HomeDetailVM?
    var viewModel1: HomeVM?
    var eventID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        eventTagsCollectionView.collectionViewLayout = createCenterAlignedLayout()
        setViewModel()
        
    }
    
    func setDetailScreenData(){
        self.eventTitleLabel.text = viewModel?.homeDetailData?.title
        self.locationLAbel.text = viewModel?.homeDetailData?.location
        self.userProfileImage.setImage(image: viewModel?.homeDetailData?.user_image,placeholder: UIImage(named: "placeholder"))
        self.userNameLabel.text = viewModel?.homeDetailData?.user_name
        self.descLabel.text = viewModel?.homeDetailData?.description
        let dateString = viewModel?.homeDetailData?.created_at

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: dateString ?? "")  {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "d MMM, yyyy"
            
            let outputString = outputDateFormatter.string(from: date)
            print(outputString) // Output: 24 Nov, 2023
            self.dateLabel.text = outputString
        } else {
            print("Invalid date format")
        }
        
        self.startEndLabel.text = "\(viewModel?.homeDetailData?.start_time ?? "")\(" - ")\(viewModel?.homeDetailData?.end_time ?? "")"
        
    }
    
    
    func setViewModel(){
        self.viewModel = HomeDetailVM(observer: self)
        self.viewModel1 = HomeVM(observer: self)
        print(eventID)
        self.viewModel?.homeDetailApi(eventID: eventID ?? "")
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
    
    @IBAction func interestedAction(_ sender: UIButton) {
        if !sender.isSelected{
            interestedBtn.backgroundColor = .black
            interestedBtn.setTitleColor(.white, for: .normal)
            let id = viewModel?.homeDetailData?.event_id
            print("EVENTSwiped====\(id)")
            viewModel1?.interestedNotInterestedApi(type: "1", eventId: id ?? "")
        }else{
            notInterestedBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            notInterestedBtn.setTitleColor(#colorLiteral(red: 168.0, green: 168.0, blue: 168.0, alpha: 0.1), for: .normal)
        }
    }
    @IBAction func notInterestedAction(_ sender: UIButton) {
        if !sender.isSelected{
            notInterestedBtn.backgroundColor = .black
            notInterestedBtn.setTitleColor(.white, for: .normal)
            let id = viewModel?.homeDetailData?.event_id
            print("EVENTSwiped====\(id)")
            viewModel1?.interestedNotInterestedApi(type: "0", eventId: id ?? "")
        }else{
            interestedBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            interestedBtn.setTitleColor(#colorLiteral(red: 168.0, green: 168.0, blue: 168.0, alpha: 0.1), for: .normal)
        }
    }
}


//MARK: - CollectionView Delegate and DataSource -
extension HomeDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.homedetailCollectionView {
//            return 4
            let k = self.viewModel?.homeDetailData?.files?.count ?? 0
            pageControl.numberOfPages = k
            print(viewModel?.homeDetailData?.files?.count ?? 0)
            return viewModel?.homeDetailData?.files?.count ?? 0
        } else {
//            return arrayName.count
            print(viewModel?.homeDetailData?.event_tags_data?.count ?? 0)
            return viewModel?.homeDetailData?.event_tags_data?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.homedetailCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDetailCVCell", for: indexPath) as! HomeDetailCVCell
            cell.homeDetailImage.setImage(image: viewModel?.homeDetailData?.files?[indexPath.row].files,placeholder: UIImage(named: "eventPlaceholder"))
            
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
            cell.interestNameButton.setTitle(viewModel?.homeDetailData?.event_tags_data?[indexPath.row].interest_name, for: .normal)
            cell.backgroundCellView.borderColor = .clear
            cell.backgroundCellView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            cell.backgroundCellView.cornerRadius = 15
//            cell.interestNameButton.setTitle(arrayName[indexPath.row], for: .normal)
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
extension HomeDetailVC: HomeDetailVMObserver{
    func observerHomeDetail() {
        setDetailScreenData()
        homedetailCollectionView.reloadData()
        eventTagsCollectionView.reloadData()
    }
    
    
}
extension HomeDetailVC: HomeVMObserver{
    func observerEventListing() {
       
    }
    
    func observerinterestedNotInterested() {
        self.popVC()
        
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
