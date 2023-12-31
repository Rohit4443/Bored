//
//  InterestVC.swift
//  Bored
//
//  Created by Dr.mac on 23/10/23.
//

import UIKit
import IQKeyboardManagerSwift
protocol InterestVCDelegate{
    func didSelectItems(_ items: [String], other: String, id:[String])
}

class InterestVC: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var interestListCollectionView: UICollectionView!
    @IBOutlet var contentBgView: UIView!
    
    @IBOutlet weak var mainBgview: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var otherTV: UITextView!
    
    
    //MARK: - Variables -
    
    var interArr = [UserInterestt]()
    
    var alredySelectedInterest: String?
    var alreadySelectedID: String?
    var delegate: InterestVCDelegate?
    var viewModel: InterestVM?
    
    
    var arrayName = ["Baking","Cooking","Dance","Swing Dancing","Picnics","Hiking","Rock Climbing","Pickleball","Plants","Yoga","Museums","Video Game","Fitness","BBQ","Singing","Festivals","Sports","Camping","Concerts","Trivia",]
    
    var completion : (() -> Void)? = nil
    var arraySelectedValue:[String] = []
    var arraySelectedID:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interArr.append(UserInterestt(id:"1",name: "Baking",isSelected: false))
        interArr.append(UserInterestt(id:"2",name: "Cooking",isSelected: false))
        interArr.append(UserInterestt(id:"3",name: "Dance",isSelected: false))
        interArr.append(UserInterestt(id:"4",name: "Swing Dancing",isSelected: false))
        interArr.append(UserInterestt(id:"5",name: "Picnics",isSelected: false))
        interArr.append(UserInterestt(id:"6",name: "Hiking",isSelected: false))
        
        print("\(alredySelectedInterest)\(alreadySelectedID)")
        setCollectionViewDelegates()
        
        interestListCollectionView.collectionViewLayout = createCenterAlignedLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.mainBgview.addGestureRecognizer(panGesture)
        configureKeboard()
        setViewModel()
        
    }
    
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        if translation.y > 100 {
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    func setViewModel(){
        if self.viewModel == nil {
            self.viewModel = InterestVM(observer: self)
        }
        //        self.viewModel?.getMyInterest()
        self.viewModel?.getEventInterest()
    }
    
    func configureKeboard() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //        IQKeyboardManager.shared.toolbarTintColor = SSColor.appBlack
        IQKeyboardManager.shared.enableAutoToolbar = true
        //        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailsVC.self, ChatViewController.self]
        IQKeyboardManager.shared.resignFirstResponder()
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIScrollView.self,UIView.self,UITextField.self,UITextView.self,UIStackView.self]
        
    }
    
    
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        interestListCollectionView.delegate = self
        interestListCollectionView.dataSource = self
        interestListCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
        
        
    }
    
    
    private func createCenterAlignedLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(40), // Variable width
                heightDimension: .absolute(50)  // Fixed height
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0), // 100% width within the section
                heightDimension: .estimated(50)        // Variable height for multiple rows
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
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        if arraySelectedValue.isEmpty {
            showMessage(message: "Interest is empty", isError: .error)
        }
        //        else if self.otherTV.text.isEmpty {
        //            showMessage(message: "Please enter other", isError: .error)
        //            print("otherTV.text is empty")
        //        }
        else if arraySelectedValue.count < 3{
            showMessage(message: "Select atleast three interests", isError: .error)
        }
        
        else {
            print(arraySelectedValue)
            DispatchQueue.main.async {
                self.delegate?.didSelectItems(self.arraySelectedValue, other: self.otherTV.text ?? "", id: self.arraySelectedID)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
    
}


//MARK: - CollectionView Delegate and DataSource -
extension InterestVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return arrayName.count
        print(viewModel?.interestData.count)
        return viewModel?.interestData.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        
        // Set the title of the button
        cell.interestNameButton.setTitle(viewModel?.interestData[indexPath.row].interest_name, for: .normal)
        
        // Check if there are already selected IDs and compare with the current item's ID
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
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedInterest = viewModel?.interestData[indexPath.row].interest_name //arrayName[indexPath.item]
        print(selectedInterest)
        let selectedID = viewModel?.interestData[indexPath.row].interest_id
        print(selectedID)
        if let cell = collectionView.cellForItem(at: indexPath) as? interestCVCell {
            
            if arraySelectedValue.contains(selectedInterest ?? "") && arraySelectedID.contains(selectedID ?? "")  {
                arraySelectedValue.removeAll { $0 == selectedInterest }
                arraySelectedID.removeAll { $0 == selectedID }
            } else {
                arraySelectedValue.append(selectedInterest ?? "")
                print(arraySelectedValue.count)
                arraySelectedID.append(selectedID ?? "")
            }
            
            let isSelected = arraySelectedValue.contains(selectedInterest ?? "")
            cell.backgroundCellView.borderColor = isSelected ? .black : .systemGray
            cell.interestNameButton.setTitleColor(isSelected ? .black : .systemGray, for: .normal)
            
        }
    }
    
}
extension InterestVC: InterestVMObserver{
    func getListing() {
        print("getListing")
        if viewModel?.interestData.count ?? 0 > 0 {
            self.interestListCollectionView.backgroundView = nil
        } else {
            self.interestListCollectionView.setBackgroundView(message: "No Data Found")
        }
        self.interestListCollectionView.reloadData()
    }
    
    
}




struct UserInterestt: Codable {
    var id, name: String?
    var isSelected :Bool?
    
    mutating func updateSelected(isSelected:Bool){
        self.isSelected = isSelected
    }
}
