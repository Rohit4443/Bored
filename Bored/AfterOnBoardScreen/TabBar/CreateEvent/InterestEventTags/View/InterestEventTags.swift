//
//  InterestEventTags.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit

protocol InterestEventTagsDelegate{
    func didSelectItems(_ items: [String], other: String, id:[String], comeToEdit:Bool)
}


class InterestEventTags: UIViewController {
    @IBOutlet weak var showInterestCollectionView: UICollectionView!
    
    @IBOutlet weak var collheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherBgView: UIView!
    @IBOutlet weak var otherViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var otherTV: UITextView!
    
    var arrayName = ["Baking","Cooking","Dance","Swing Dancing","Picnics","Hiking","Rock Climbing","Pickleball","Plants","Yoga","Museums","Video Game","Fitness","BBQ","Singing","Festivals","Sports","Camping","Concerts","Trivia",]
    var completion : (() -> Void)? = nil
    var arraySelectedValue:[String] = []
    var selectedInterest: String?
    var arraySelectedID:[String] = []
    var comefrom: String?
    
    var alredySelectedInterest: String?
    var alreadySelectedID: String?
    var comeToEdit: Bool?
    var viewModel: InterestVM?
    var selectedArray: [InterestsDatum]?
    
    var delegate: InterestEventTagsDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        showInterestCollectionView.collectionViewLayout = createCenterAlignedLayout()
//        collheightConstraint.constant = CGFloat(50*arrayName.count)
        print(selectedArray?.count)
        print(alreadySelectedID)
        setViewModel()
        
//        if let selectedInterests = selectedArray {
//            arraySelectedValue = selectedInterests.map { $0.interest_name ?? "" }
//            arraySelectedID = selectedInterests.map { $0.interest_id ?? "" }
//        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if comefrom == "eventTags"{
//            otherBgView.isHidden = true
//            otherViewHeightConstraint.constant = 0

        }else{

        }
    }
    
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        showInterestCollectionView.delegate = self
        showInterestCollectionView.dataSource = self
        showInterestCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
        
        
    }
   
    func setViewModel(){
        if self.viewModel == nil {
            self.viewModel = InterestVM(observer: self)
        }
        self.viewModel?.getInterest()
//        self.viewModel?.getEventInterest()
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
    
    func getSelectedItems() -> [InterestsDatum] {
        var selectedItems: [InterestsDatum] = []

        for indexPath in showInterestCollectionView.indexPathsForVisibleItems {
            if let cell = showInterestCollectionView.cellForItem(at: indexPath) as? interestCVCell,
               cell.backgroundCellView.borderColor == UIColor.black {
                if let selectedInterest = viewModel?.interestData[indexPath.row] {
                    print(selectedInterest)
                }
            }
        }

        return selectedItems
    }


    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        
        guard !arraySelectedValue.isEmpty else {
            showMessage(message: "Please select at least one interest from the list", isError: .error)
            return
        }

        let selectedItems = getSelectedItems()
        for item in selectedItems {
            print(item) // This will print each selected item
        }

        delegate?.didSelectItems(arraySelectedValue, other: otherTV.text, id: arraySelectedID, comeToEdit: false)
        popVC()

        
//        guard !arraySelectedValue.isEmpty, let text = otherTV.text, !text.isEmpty else {
//            if arraySelectedValue.isEmpty {
//                showMessage(message: "Please select interest from the list", isError: .error)
//            }
//            if otherTV.text.isEmpty {
//                showMessage(message: "Please enter other", isError: .error)
//            }
//            return
//        }
//        let selectedItems = getSelectedItems()
//        for item in selectedItems {
//            print(item) // This will print each selected item
//        }
//        delegate?.didSelectItems(arraySelectedValue, other: text, id: arraySelectedID, comeToEdit: false)
//        popVC()
    }
}


//MARK: - CollectionView Delegate and DataSource -
extension InterestEventTags : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.interestData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        let currentInterest = viewModel?.interestData[indexPath.row]
        
        cell.interestNameButton.setTitle(currentInterest?.interest_name, for: .normal)
        
        if let selectedIDs = alreadySelectedID?.components(separatedBy: ","), // Split the string into an array
           let currentInterestID = viewModel?.interestData[indexPath.row].interest_id,
           selectedIDs.contains(currentInterestID) {
            print(selectedIDs)
            // Handle the appearance for selected items
            cell.backgroundCellView.borderColor = .black
            cell.interestNameButton.setTitleColor(.black, for: .normal)
            // Add to the selected arrays
            if let currentInterestName = viewModel?.interestData[indexPath.row].interest_name {
                arraySelectedValue.append(currentInterestName)
                arraySelectedID.append(currentInterestID)
            }
        } else {
            // Handle the appearance for non-selected items
            cell.backgroundCellView.borderColor = .systemGray
            cell.interestNameButton.setTitleColor(.systemGray, for: .normal)
        }

        
//        if let selectedInterests = selectedArray,let interestId = currentInterest?.interest_id,
//            selectedInterests.contains(where: { $0.interest_id == interestId }) {
//            // The current interest is among the selected items in selectedArray
//            cell.backgroundCellView.setBorder(.black, corner: 20, 1)
//            cell.interestNameButton.setTitleColor(.black, for: .normal)
//        } else {
//            // The current interest is not among the selected items in selectedArray
//            cell.backgroundCellView.setBorder(.lightGray, corner: 20, 1)
//            cell.interestNameButton.setTitleColor(.systemGray, for: .normal)
//        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedInterest = viewModel?.interestData[indexPath.row].interest_name,
              let selectedID = viewModel?.interestData[indexPath.row].interest_id else {
            return
        }

        let isSelected = arraySelectedID.contains(selectedID)
        if isSelected {
            if let index = arraySelectedID.firstIndex(of: selectedID) {
                arraySelectedValue.remove(at: index)
                arraySelectedID.remove(at: index)
            }
        } else {
            arraySelectedValue.append(selectedInterest)
            arraySelectedID.append(selectedID)
        }

        if let cell = collectionView.cellForItem(at: indexPath) as? interestCVCell {
            cell.backgroundCellView.borderColor = isSelected ? .systemGray : .black
            cell.interestNameButton.setTitleColor(isSelected ? .systemGray : .black, for: .normal)
        }
    }

    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedInterest = viewModel?.interestData[indexPath.row].interest_name //arrayName[indexPath.item]
//        print(selectedInterest)
//        let selectedID = viewModel?.interestData[indexPath.row].interest_id
//        print(selectedID)
//        if let cell = collectionView.cellForItem(at: indexPath) as? interestCVCell {
//
//            if let selectedInterest = selectedInterest, let selectedID = selectedID {
//                if arraySelectedValue.contains(selectedInterest), arraySelectedID.contains(selectedID) {
//                    arraySelectedValue.removeAll { $0 == selectedInterest }
//                    arraySelectedID.removeAll { $0 == selectedID }
//                } else {
//                    arraySelectedValue.append(selectedInterest)
//                    arraySelectedID.append(selectedID)
//                }
//            }
//
////            if arraySelectedValue.contains(selectedInterest ?? "") {
////                arraySelectedValue.removeAll { $0 == selectedInterest }
////            } else {
////                arraySelectedValue.append(selectedInterest ?? "")
////                arraySelectedID.append(selectedID ?? "")
////            }
//
//            let isSelected = arraySelectedValue.contains(selectedInterest ?? "")
//            cell.backgroundCellView.borderColor = isSelected ? .black : .systemGray
//            cell.interestNameButton.setTitleColor(isSelected ? .black : .systemGray, for: .normal)
//
//        }
//    }
    
}
extension InterestEventTags: InterestVMObserver{
    func getListing() {
        print("getListing")
        if viewModel?.interestData.count ?? 0 > 0 {
            self.showInterestCollectionView.backgroundView = nil
        } else {
            self.showInterestCollectionView.setBackgroundView(message: "No Data Found")
        }
        self.showInterestCollectionView.reloadData()
    }
    
    
}
