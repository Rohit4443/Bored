//
//  InterestVC.swift
//  Bored
//
//  Created by Dr.mac on 23/10/23.
//

import UIKit


class InterestVC: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var interestListCollectionView: UICollectionView!
    @IBOutlet var contentBgView: UIView!
    
    @IBOutlet weak var mainBgview: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    //MARK: - Variables -
    
    var interArr = [UserInterestt]()



    var arrayName = ["Baking","Cooking","Dance","Swing Dancing","Picnics","Hiking","Rock Climbing","Pickleball","Plants","Yoga","Museums","Video Game","Fitness","BBQ","Singing","Festivals","Sports","Camping","Concerts","Trivia",]
   
    var completion : (() -> Void)? = nil
    var arraySelectedValue:[String] = []
    var selectedInterest: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interArr.append(UserInterestt(id:"1",name: "Baking",isSelected: false))
          interArr.append(UserInterestt(id:"2",name: "Cooking",isSelected: false))
          interArr.append(UserInterestt(id:"3",name: "Dance",isSelected: false))
          interArr.append(UserInterestt(id:"4",name: "Swing Dancing",isSelected: false))
          interArr.append(UserInterestt(id:"5",name: "Picnics",isSelected: false))
          interArr.append(UserInterestt(id:"6",name: "Hiking",isSelected: false))
        
        
        
        
        setCollectionViewDelegates()
        
        interestListCollectionView.collectionViewLayout = createCenterAlignedLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                        self.mainBgview.addGestureRecognizer(panGesture)

     
        
    }

    
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: self.view)
            if translation.y > 100 {
                self.dismiss(animated: true, completion: nil)
    
            }
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
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}


//MARK: - CollectionView Delegate and DataSource -
extension InterestVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        cell.interestNameButton.setTitle(arrayName[indexPath.row], for: .normal);
        
        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedInterest = arrayName[indexPath.item]
        
        if let cell = collectionView.cellForItem(at: indexPath) as? interestCVCell {
            
            if arraySelectedValue.contains(selectedInterest) {
                arraySelectedValue.removeAll { $0 == selectedInterest }
            } else {
                arraySelectedValue.append(selectedInterest)
            }
            
            let isSelected = arraySelectedValue.contains(selectedInterest)
            cell.backgroundCellView.borderColor = isSelected ? .black : .systemGray
            cell.interestNameButton.setTitleColor(isSelected ? .black : .systemGray, for: .normal)
            
        }
    }
    
}
struct UserInterestt: Codable {
    var id, name: String?
    var isSelected :Bool?
    
    mutating func updateSelected(isSelected:Bool){
        self.isSelected = isSelected
    }
}
