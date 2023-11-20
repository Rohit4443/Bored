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
    //MARK: - Variables -
    var arrayName = ["Baking","Rock Climbing","Pickleball","Baking","Rock Climbing"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionViewDelegates()
        setTableViewDelegates()
        interestCollectionView.collectionViewLayout = createLeftAlignedLayout()
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
    
    func setTableViewDelegates(){
        interestUserTableView.delegate = self
        interestUserTableView.dataSource = self
        interestUserTableView.register(UINib(nibName: "SearchUserTVCell", bundle: nil), forCellReuseIdentifier: "SearchUserTVCell")
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
        self.pushViewController(vc, true)
    }
    
}


//MARK: - CollectionView Delegate and DataSource -
extension MyEventDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myEventdetailCollectionView {
            return 4
        } else {
            return arrayName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myEventdetailCollectionView {
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

//MARK: - TableView Delegate and DataSource -
extension MyEventDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTVCell", for: indexPath) as! SearchUserTVCell
        cell.deleteButton.isHidden = true
        cell.widthConstraintsButton.constant = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
