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
    var comeToEdit: Bool?
    var interestArray: [String] = []
    var interestItems: String?
    var selectedInterestedItem: [String]?
    var interestID: String?
    var profileSignUpImage: UIImage?
    var signUpImage: Data?
    var otherInterest: String?
    
    
    var viewModel1: EditProfileVM?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        createDatePicker()
        setCollectionViewDelegates()
        setViewModel()
        setViewModel1()
        print(comeToEdit)
        
    }
    
    func setViewModel1(){
        self.viewModel1 = EditProfileVM(observer: self)
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
        
        let isValidFirstName = Validator.validateName(name: firstNameTextField.text ?? "", message: "Please enter First Name")
        
        let isValidLastName = Validator.validateName(name: lastNameTextField.text ?? "", message: "Please enter Last Name")
        
        guard isValidFirstName.0 == true else {
            Singleton.showMessage(message: isValidFirstName.1, isError: .error)
            return
        }
        guard isValidLastName.0 == true else {
            Singleton.showMessage(message: isValidLastName.1, isError: .error)
            return
        }
        
        viewModel1?.editProfileApi(firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", email: UserDefaultsCustom.getUserData()?.email ?? "", password: UserDefaultsCustom.getUserData()?.password ?? "", interest: self.interestID ?? "", gender: self.gender ?? "", dob: self.birthdayTextField.text ?? "", deviceType: "2", image: self.signUpImage ?? Data(), intersetName: self.otherInterest ?? "", aboutMe: aboutMeTextView.text ?? "")
        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    
    @IBAction func interestCollectionButton(_ sender: UIButton) {
        let vc = InterestEventTags()
        vc.delegate = self
        vc.selectedArray = viewModel?.interestData
        vc.alredySelectedInterest = interestItems
        vc.alreadySelectedID = interestID
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
        if comeToEdit == true{
            return viewModel?.interestData.count ?? 0
        }else{
            return selectedInterestedItem?.count ?? 0
        }
//        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        if comeToEdit == true{
            cell.interestNameButton.setTitle(viewModel?.interestData[indexPath.row].interest_name, for: .normal)
        }else{
            cell.interestNameButton.setTitle(selectedInterestedItem?[indexPath.row], for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if comeToEdit == true{
            let text = viewModel?.interestData[indexPath.row].interest_name ?? ""
            let width = UILabel.textWidth(font: UIFont.setCustom(.Poppins_Regular, 10), text: text)
            return CGSize(width: (width + 71) , height: collectionView.frame.size.height)
        }else{
            let text = selectedInterestedItem?[indexPath.row] ?? ""
            let width = UILabel.textWidth(font: UIFont.setCustom(.Poppins_Regular, 10), text: text)
            return CGSize(width: (width + 71) , height: collectionView.frame.size.height)
        }
//        return CGSize()
    }
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        profileImage.image  = tempImage
        print(tempImage)
        
        self.profileSignUpImage = tempImage
        let imageData = tempImage.jpegData(compressionQuality: 0.8)
        print(imageData)
        self.signUpImage = imageData
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
            self.imagePickerController.allowsEditing = true
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
    func observerLogOut() {
       
    }
    
    func observerGetProfile() {
        let image = viewModel?.userData?.image ?? ""
        print(image)
        let url = URL(string:image)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data) ?? UIImage()
            print(image)
            let profile = image.jpegData(compressionQuality: 0.8)
            print(profile)
            self.signUpImage = profile
            print(self.signUpImage)
        }

        
        self.profileImage.setImage(image: viewModel?.userData?.image, placeholder: UIImage(named: "placeholder"))
        self.firstNameTextField.text = viewModel?.userData?.first_name
        self.lastNameTextField.text = viewModel?.userData?.last_name
        self.birthdayTextField.text = viewModel?.userData?.dob
        self.interestsCollectionView.reloadData()
        self.gender = viewModel?.userData?.gender
        self.interestID = viewModel?.userData?.interests
        self.aboutMeTextView.text = viewModel?.userData?.about_me
        if viewModel?.userData?.gender == "1"{
            malegenderBtn.setBorder(.black, corner: 37.5, 2)
        }else{
            femaleGenderBtn.setBorder(.black, corner: 37.5, 2)
        }
        
        
    }
    
    
}
extension EditProfileVC: EditProfileVMObserver{
    func observerEditProfile() {
        self.popVC()
    }
    
    
}
extension EditProfileVC: InterestEventTagsDelegate{
   
    func didSelectItems(_ items: [String], other: String, id: [String],comeToEdit: Bool) {
        print("Selected items: \(items) \(other)\(id)")
        selectedInterestedItem = items
        print(selectedInterestedItem)
        let itemsString = items.joined(separator: ",")
        print(itemsString)
        interestItems = itemsString
        print(interestItems)
        self.otherInterest = other
        let itemId = id.joined(separator: ",")
        print(itemId)
        self.interestID = itemId
        self.comeToEdit = comeToEdit
        print(self.comeToEdit)
        interestsCollectionView.reloadData()
    }
 
    
}
