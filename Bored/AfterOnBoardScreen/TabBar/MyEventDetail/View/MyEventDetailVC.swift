//
//  MyEventDetailVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class MyEventDetailVC: UIViewController {

    @IBOutlet weak var myEventdetailCollectionView: UICollectionView!
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var interestUserTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var startEndTimeLAbel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    //MARK: - Variables -
    var eventID: String?
    var viewModel: MyEventDetailVM?
    var arrayName = ["Baking","Rock Climbing","Pickleball","Baking","Rock Climbing"]
    override func viewDidLoad() {
        super.viewDidLoad()
        print(eventID)
        setCollectionViewDelegates()
        setTableViewDelegates()
        interestCollectionView.collectionViewLayout = createLeftAlignedLayout()
        setViewModel()
    }
    
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        
        myEventdetailCollectionView.delegate = self
        interestCollectionView.delegate = self
        
        myEventdetailCollectionView.dataSource = self
        interestCollectionView.dataSource = self
        
        myEventdetailCollectionView.register(UINib(nibName: "HomeDetailCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeDetailCVCell")
        
        interestCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
        
        pageControl.hidesForSinglePage = true
        self.myEventdetailCollectionView.isPagingEnabled = true
    
        
    }
    
    func setData(){
        self.titleLabel.text = viewModel?.eventData?.title
        self.locationLabel.text = viewModel?.eventData?.location
        self.descLabel.text = viewModel?.eventData?.description
        self.startEndTimeLAbel.text = "\(viewModel?.eventData?.start_time ?? "")\(" - ")\(viewModel?.eventData?.end_time ?? "")"
        
        let date = viewModel?.eventData?.created_at
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: date ?? "")  {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "d MMM, yyyy"
            
            let outputString = outputDateFormatter.string(from: date)
            print(outputString) // Output: 24 Nov, 2023
            self.dateLabel.text = outputString
        } else {
            print("Invalid date format")
        }
        
    }
    
    func setTableViewDelegates(){
        interestUserTableView.delegate = self
        interestUserTableView.dataSource = self
        interestUserTableView.register(UINib(nibName: "SearchUserTVCell", bundle: nil), forCellReuseIdentifier: "SearchUserTVCell")
    }
    
    
    func setViewModel(){
        self.viewModel = MyEventDetailVM(observer: self)
        self.viewModel?.eventDetailApi(eventID: eventID ?? "")
    }
    
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .estimated(40),
              heightDimension: .absolute(40)
            )
          )
          
          let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .estimated(40)
            ),
            subitems: [item]
          )
          group.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 10)
          group.interItemSpacing = .fixed(0)
          
          return UICollectionViewCompositionalLayout(section: .init(group: group))
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
    
    @IBAction func menuAction(_ sender: UIButton) {
        let vc = EditDeleteEventPopUpVC()
        vc.controller = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    
    @IBAction func viewAllUsersAction(_ sender: UIButton) {
        let vc = InterestedUsersVC()
        vc.arrayListing = viewModel?.eventData?.interested_users
        self.pushViewController(vc, true)
    }
    
}


//MARK: - CollectionView Delegate and DataSource -
extension MyEventDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myEventdetailCollectionView {
//            return 4
            let k = viewModel?.eventData?.files?.count ?? 0
            pageControl.numberOfPages = k
            print("\(k)")
            return viewModel?.eventData?.files?.count ?? 0
        } else {
//            return arrayName.count
            return viewModel?.eventData?.event_tags_data?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myEventdetailCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDetailCVCell", for: indexPath) as! HomeDetailCVCell
            cell.homeDetailImage.setImage(image: viewModel?.eventData?.files?[indexPath.row].files,placeholder: UIImage(named: "eventPlaceholder"))
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
            cell.backgroundCellView.borderColor = .clear
            cell.backgroundCellView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            cell.backgroundCellView.cornerRadius = 15
            cell.interestNameButton.setTitle(viewModel?.eventData?.event_tags_data?[indexPath.row].interest_name, for: .normal)
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

//MARK: - TableView Delegate and DataSource -
extension MyEventDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
        return viewModel?.eventData?.interested_users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTVCell", for: indexPath) as! SearchUserTVCell
        cell.deleteButton.isHidden = true
        cell.widthConstraintsButton.constant = 0
        cell.profileImage.setImage(image: viewModel?.eventData?.interested_users?[indexPath.row].image,placeholder: UIImage(named: "placeholder"))
        cell.nameLabel.text = viewModel?.eventData?.interested_users?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension MyEventDetailVC: MyEventDetailVMObserver{
    func observerEventDetail() {
        setData()
        myEventdetailCollectionView.reloadData()
        interestCollectionView.reloadData()
        interestUserTableView.reloadData()
    }
    
    
}
