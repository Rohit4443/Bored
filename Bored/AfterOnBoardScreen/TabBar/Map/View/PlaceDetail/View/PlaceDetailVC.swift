//
//  PalceDetailVC.swift
//  Bored
//
//  Created by Dr.mac on 30/10/23.
//

import UIKit

class PlaceDetailVC: UIViewController {
    @IBOutlet weak var placeDetailCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var descLAbel: UILabel!
    
    
    var arrayName = ["Baking","Cooking","Dance","Swing Dancing","Picnics"]
    var detail: MapListingData?
    var viewModel: ChatListingVM?
    var viewModel1: PlaceDetailVM?
    var age : String?
    var otherID:String?
    var comFromSearch: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        placeDetailCollectionView.collectionViewLayout = createLeftAlignedLayout()
        setData()
        setViewModel()
        print(comFromSearch)
        print(otherID)
    }
    
    func setViewModel(){
        if comFromSearch == true{
            self.viewModel1 = PlaceDetailVM(observer: self)
            print(otherID)
            viewModel1?.mapDetailApi(otherUserID: otherID ?? "")
            self.viewModel = ChatListingVM(observer: self)
        }else{
            self.viewModel = ChatListingVM(observer: self)
            self.viewModel1 = PlaceDetailVM(observer: self)
        }
    }
    
    func calculateAge(birthdate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        let age = ageComponents.year ?? 0
        
        return age
    }
    
    
    func setData(){
        self.titleLabel.text = detail?.name
        self.profileImage.setImage(image: detail?.image,placeholder: UIImage(named: "placeholder"))
        self.nameLabel.text = detail?.name
        self.descLAbel.text = detail?.about_me
        let date = detail?.dob 
        print(date)
        // Example birthdate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Date format matching your DOB string
        let dobString = date // Replace this with your DOB string
        let dobDate = dateFormatter.date(from: dobString ?? "")
        print(dobDate)
        // Calculate age
        let age = calculateAge(birthdate: dobDate ?? Date())
        print("Age: \(age)")
        if detail?.gender == "1"{
            self.genderLabel.text = "Male"
        }else{
            self.genderLabel.text = "Female"
        }
        
        self.ageLabel.text = "\(age)\(" Years")"
        
    }
    
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        placeDetailCollectionView.delegate = self
        placeDetailCollectionView.dataSource = self
        placeDetailCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
        placeDetailCollectionView.reloadData()
    }
    
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
          let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
              widthDimension: .estimated(40),
              heightDimension: .absolute(37)
            )
          )
          
          let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .estimated(30)
            ),
            subitems: [item]
          )
          group.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 10)
          group.interItemSpacing = .fixed(0)
          
          return UICollectionViewCompositionalLayout(section: .init(group: group))
        }


    @IBAction func menuAction(_ sender: UIButton) {
        if comFromSearch == true{
            let vc = BlockReportPopUpVC()
            vc.controller = self
            vc.delegate = self
            vc.userID = detail?.id
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, true)
        }else{
            let vc = BlockReportPopUpVC()
            vc.controller = self
            vc.userID = detail?.id
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, true)
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        popVC()
    }
    
    @IBAction func ChatAction(_ sender: UIButton) {
        if comFromSearch == true{
            let id = viewModel1?.mapDetail?.id ?? ""
            viewModel?.createChatRoomApi(receiverId: id )
        }else{
            let id = detail?.id ?? ""
            viewModel?.createChatRoomApi(receiverId: id )
        }
        
        
//        let vc = OneToOneChatVC()
//        self.pushViewController(vc, true)
        
    }
}

//MARK: - CollectionView Delegate and DataSource -
extension PlaceDetailVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return arrayName.count
        if comFromSearch == true{
            return viewModel1?.mapDetail?.interestsData?.count ?? 0
        }else{
            return detail?.interestsData?.count ?? 0
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        if comFromSearch == true{
            cell.interestNameButton.setTitle(viewModel1?.mapDetail?.interestsData?[indexPath.row].interest_name, for: .normal);
            cell.backgroundCellView.borderColor = .clear
            cell.backgroundCellView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            cell.backgroundCellView.cornerRadius = 12
           
            cell.interestNameButton.setTitle(viewModel1?.mapDetail?.interestsData?[indexPath.row].interest_name, for: .normal)
            cell.interestNameButton.setTitleColor(UIColor.black, for: .normal)
            
            let fontSize: CGFloat = 12
            let font = UIFont.setCustom(.Poppins_Regular, 12)
                   cell.interestNameButton.setAttributedTitle(NSAttributedString(string: cell.interestNameButton.currentTitle!, attributes: [.font: font]), for: .normal)
            let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

              
            cell.backgroundCellView.frame.size = CGSize(width: cell.backgroundCellView.frame.width, height: 19)
        }else{
            cell.interestNameButton.setTitle(detail?.interestsData?[indexPath.row].interest_name, for: .normal);
            cell.backgroundCellView.borderColor = .clear
            cell.backgroundCellView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            cell.backgroundCellView.cornerRadius = 12
           
            cell.interestNameButton.setTitle(detail?.interestsData?[indexPath.row].interest_name, for: .normal)
            cell.interestNameButton.setTitleColor(UIColor.black, for: .normal)
            
            let fontSize: CGFloat = 12
            let font = UIFont.setCustom(.Poppins_Regular, 12)
                   cell.interestNameButton.setAttributedTitle(NSAttributedString(string: cell.interestNameButton.currentTitle!, attributes: [.font: font]), for: .normal)
            let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

              
            cell.backgroundCellView.frame.size = CGSize(width: cell.backgroundCellView.frame.width, height: 19)
        }
        
        
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }


}
extension PlaceDetailVC: ChatListingVMObserver{
    func chatDelete() {
       
    }
    
    func observerChatListing() {
      
    }
    
    func createRoom() {
        if comFromSearch == true{
            let vc = OneToOneChatVC()
            vc.roomID = viewModel?.chatRoomData?.room_id
            vc.recieverID = Int(viewModel?.chatRoomData?.receiver_id ?? "")
            self.pushViewController(vc, true)
        }else{
            let vc = OneToOneChatVC()
            vc.roomID = viewModel?.chatRoomData?.room_id
            vc.recieverID = Int(viewModel?.chatRoomData?.receiver_id ?? "")
            self.pushViewController(vc, true)
        }
        
        
    }
    
    
}
extension PlaceDetailVC: PlaceDetailVMObserver{
    func blockUser(){
        print("user Blocked")
    }
  
    func observerDetail() {
        self.titleLabel.text = viewModel1?.mapDetail?.name
        self.profileImage.setImage(image: viewModel1?.mapDetail?.image,placeholder: UIImage(named: "placeholder"))
        self.nameLabel.text = viewModel1?.mapDetail?.name
        self.descLAbel.text = viewModel1?.mapDetail?.about_me
        let date = viewModel1?.mapDetail?.dob
        print(date)
        // Example birthdate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Date format matching your DOB string
        let dobString = date // Replace this with your DOB string
        let dobDate = dateFormatter.date(from: dobString ?? "")
        print(dobDate)
        // Calculate age
        let age = calculateAge(birthdate: dobDate ?? Date())
        print("Age: \(age)")
        if viewModel1?.mapDetail?.gender == "1"{
            self.genderLabel.text = "Male"
        }else{
            self.genderLabel.text = "Female"
        }
        
        self.ageLabel.text = "\(age)\(" Years")"
        placeDetailCollectionView.reloadData()
    }
    
    
}
extension PlaceDetailVC: BlockReportPopUpVCDelegate{
    func blockUserAction() {
        print("Blockeddddd")
        dismiss(animated: true)
        if comFromSearch == true{
            let id = viewModel1?.mapDetail?.id
            print(id)
            self.viewModel1?.blockUserApi(otherUserID: id ?? "", type: "1")
        }else{
            let id = detail?.id
            print(id)
            self.viewModel1?.blockUserApi(otherUserID: id ?? "", type: "1")
        }
    }
    
}
