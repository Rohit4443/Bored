//
//  EditProfileVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class EditProfileVC: UIViewController {

    //MARK: - IBOutlets -
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderMaleButton: UIButton!
    @IBOutlet weak var genderFemaleButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var malegenderBtn: UIButton!
    @IBOutlet weak var femaleGenderBtn: UIButton!
    
    //MARK: - Variables -
   
    var imagePickerController = UIImagePickerController()
    var viewModel: ProfileVM?
    var gender: String?
    var comeFrom: Bool?
    var interestArray: [String] = []
    var interestItems: String?
    var selectedInterestedItem: [String]?
    var interestID: String?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        createDatePicker()
        setCollectionViewDelegates()
        setViewModel()
        print(comeFrom)
        
    }
    
    func setViewModel(){
        self.viewModel = ProfileVM(observer: self)
        viewModel?.getProfileApi()
    }
    
    func setCollectionViewDelegates(){
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self
        interestsCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
       
    }

    //MARK: - CustomFunction -
    func createDatePicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        birthdayTextField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDoneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func datePickerDoneButtonTapped() {
        
        let datePicker = birthdayTextField.inputView as! UIDatePicker
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        birthdayTextField.text = formattedDate
        birthdayTextField.resignFirstResponder()
    }
        
        
    //MARK: - IBAction -
    @IBAction func cameraPickPhotoAction(_ sender: UIButton) {
        openCamera()
        
    }
    
   
    
    @IBAction func saveAction(_ sender: UIButton) {

        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    
    @IBAction func interestCollectionButton(_ sender: UIButton) {
        let vc = InterestEventTags()
        vc.comeFromEdit = true
        vc.selectedArray = viewModel?.interestData
        self.pushViewController(vc, true)
//        let vc = InterestVC()
//        vc.delegate = self
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: true, completion: {
//            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
//        })
//
    
    }

    @IBAction func maleAction(_ sender: UIButton) {
        
        if !sender.isSelected {
            // Female button is not selected, set the border and gender accordingly
            sender.setBorder(.black, corner: 37.5, 2)
            gender = "1"
            
            // Additionally, if there's a male button, you might want to clear its border
            genderFemaleButton.setBorder(.clear, corner: 37.5, 2)
            genderFemaleButton.isSelected = false
        } else {
            // Female button is already selected, clear the border and set the gender to male
            sender.setBorder(.clear, corner: 37.5, 2)
            gender = "2"
        }
        
        // Toggle the selected state of the female button
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func femaleAction(_ sender: UIButton) {
        if !sender.isSelected {

            sender.setBorder(.black, corner: 37.5, 2)
            gender = "2"

            genderMaleButton.setBorder(.clear, corner: 37.5, 2)
            genderMaleButton.isSelected = false
        } else {

            sender.setBorder(.clear, corner: 37.5, 2)
            gender = "1"
        }
        sender.isSelected = !sender.isSelected
    }
    
}
extension EditProfileVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if comeFrom == true{
            return viewModel?.interestData.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        if comeFrom == true{
            cell.interestNameButton.setTitle(viewModel?.interestData[indexPath.row].interest_name, for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if comeFrom == true{
            let text = viewModel?.interestData[indexPath.row].interest_name ?? ""
            let width = UILabel.textWidth(font: UIFont.setCustom(.Poppins_Regular, 10), text: text)
            return CGSize(width: (width + 72) , height: collectionView.frame.size.height)
        }
        return CGSize()
    }
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImage.image  = tempImage
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func openCamera(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Camera", style: .default){ [self] action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera;
                imagePickerController.allowsEditing = true
                self.imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Camera not found", message: "This device has no camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
                present(alert, animated: true,completion: nil)
            }
        }
        let action1 = UIAlertAction(title: "Gallery", style: .default){ action in
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.delegate = self
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
}
extension EditProfileVC: ProfileVMObserver{
    func observerGetProfile() {
        self.profileImage.setImage(image: viewModel?.userData?.image)
        self.firstNameTextField.text = viewModel?.userData?.first_name
        self.lastNameTextField.text = viewModel?.userData?.last_name
        self.birthdayTextField.text = viewModel?.userData?.dob
        self.interestsCollectionView.reloadData()
        if viewModel?.userData?.gender == "1"{
            malegenderBtn.setBorder(.black, corner: 37.5, 2)
        }else{
            femaleGenderBtn.setBorder(.black, corner: 37.5, 2)
        }
        
        
    }
    
    
}
extension EditProfileVC: InterestVCDelegate{
    func didSelectItems(_ items: [String], other: String, id: [String]) {
        print("Selected items: \(items) \(other)\(id)")
        selectedInterestedItem = items
        print(selectedInterestedItem)
        let itemsString = items.joined(separator: ",")
        print(itemsString)
        interestItems = itemsString
        print(interestItems)
        
        let itemId = id.joined(separator: ",")
        print(itemId)
        self.interestID = itemId
        interestsCollectionView.reloadData()
    }
 
    
}
