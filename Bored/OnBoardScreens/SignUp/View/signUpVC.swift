//
//  signUpVC.swift
//  Bored
//
//  Created by Dr.mac on 20/10/23.
//

import UIKit

class signUpVC: UIViewController {
    
    
    
    //MARK: - IBOutlets -
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderMaleButton: UIButton!
    @IBOutlet weak var genderFemaleButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var checkUncheckButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    //MARK: - Variables -
   
    var imagePickerController = UIImagePickerController()
    var gender: String?
    var viewModel: SignUpVM?
    var interestItems: String?
    var selectedInterestedItem: [String]?
    var interestID: String?
    var profileSignUpImage: UIImage?
    var signUpImage: Data?
    var signUpImageBase64String: String?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        setCollectionViewDelegates()
        setViewModel()
        
    }
    
    func setCollectionViewDelegates(){
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self
        interestsCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
       
    }
    
    func setViewModel(){
        self.viewModel = SignUpVM(observer: self)
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
    
    @IBAction func checkUncheckAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.setBackgroundImage(UIImage(named: "ic_uncheck"), for: .selected)
        
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
        print(gender)
        signUPApi()
        
        
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
      
        let vc = LoginVC()
        self.navigationController?.navigationBar.isHidden = true
        self.pushViewController(vc, true)
    }
    
    @IBAction func interestCollectionButton(_ sender: UIButton) {
        let vc = InterestVC()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }

    @IBAction func maleBtnAction(_ sender: UIButton) {
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
        
        
        
//        if sender.isSelected == true{
//            genderFemaleButton.setBorder(.black, corner: 37.5, 2)
//            gender = 2
//        }else{
//            genderMaleButton.setBorder(.clear, corner: 37.5, 2)
//            gender = 1
//        }
    }

    
    @IBAction func femaleBtnAction(_ sender: UIButton) {
        
        if !sender.isSelected {
            // Female button is not selected, set the border and gender accordingly
            sender.setBorder(.black, corner: 37.5, 2)
            gender = "2"
            
            // Additionally, if there's a male button, you might want to clear its border
            genderMaleButton.setBorder(.clear, corner: 37.5, 2)
            genderMaleButton.isSelected = false
        } else {
            // Female button is already selected, clear the border and set the gender to male
            sender.setBorder(.clear, corner: 37.5, 2)
            gender = "1"
        }
        
        // Toggle the selected state of the female button
        sender.isSelected = !sender.isSelected
        
        
        
//        if sender.isSelected == true{
//            genderFemaleButton.setBorder(.black, corner: 37.5, 2)
//            gender = 2
//        }else{
//            genderMaleButton.setBorder(.clear, corner: 37.5, 2)
//            gender = 1
//        }
    }
    
    @IBAction func passwordEyeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
    
    //MARK: SignUp api
    
    func signUPApi() {
        let isValidFirstName = Validator.validateName(name: firstNameTextField.text ?? "", message: "Please enter First Name")
        
        let isValidLastName = Validator.validateName(name: lastNameTextField.text ?? "", message: "Please enter Last Name")
        
        let isValidEmail = Validator.validateEmail(candidate: emailTextField.text ?? "")
        
        let isValidPassword = Validator.validatePassword(password: passwordTextField.text ?? "")

        let isValidCollectionView = Validator.validateCollectionView(collectionView: interestsCollectionView)
        
        let isValidBirthday = Validator.validateName(name: birthdayTextField.text ?? "", message: "Please select DOB")
        
        let isValidGender = Validator.validateButtonSelection(buttons: [genderMaleButton, genderFemaleButton])
        let isValidDisp = Validator.validateDescription(words: aboutMeTextView.text ?? "")
        
        guard isValidFirstName.0 == true else {
            Singleton.showMessage(message: isValidFirstName.1, isError: .error)
            return
        }
        guard isValidLastName.0 == true else {
            Singleton.showMessage(message: isValidLastName.1, isError: .error)
            return
        }
        
        guard isValidEmail.0 == true else {
            Singleton.showMessage(message: isValidEmail.1, isError: .error)
            return
        }

        guard isValidPassword.0 == true else {
            Singleton.showMessage(message: isValidPassword.1, isError: .error)
            return
        }
        
        guard isValidCollectionView.0 == true else {
            Singleton.showMessage(message: isValidCollectionView.1, isError: .error)
            return
        }
        guard isValidBirthday.0 == true else {
            Singleton.showMessage(message: isValidBirthday.1, isError: .error)
            return
        }
        guard isValidGender.0 == true else {
            Singleton.showMessage(message: isValidGender.1, isError: .error)
            return
        }
        guard isValidDisp.0 == true else {
            Singleton.showMessage(message: isValidDisp.1, isError: .error)
            return
        }
        if self.checkUncheckButton.isSelected == false{
            showMessage(message: "Please agree with terms & conditions.", isError: .error)
        }else{
            let gender = "\(gender ?? "")"
            
            viewModel?.signUPImageApi(firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", interests: interestID ?? "", gender: gender, dob: birthdayTextField.text ?? "", deviceType: "1", image: signUpImage ?? Data(), interestName: interestItems ?? "")
            
//            viewModel?.signUPApi(firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", interests: interestID ?? "", gender: gender, dob: birthdayTextField.text ?? "", deviceType: "1", image: signUpImage ?? Data(), interestName: interestItems ?? "")
        }
        
    }
    
}

extension signUpVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedInterestedItem?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        cell.interestNameButton.setTitle(selectedInterestedItem?[indexPath.row], for: .normal)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = selectedInterestedItem?[indexPath.row] ?? ""
        let width = UILabel.textWidth(font: UIFont.setCustom(.Poppins_Regular, 10), text: text)
        return CGSize(width: (width + 72) , height: collectionView.frame.size.height)
    }
    
    
}


extension signUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImage.image  = tempImage
        print(tempImage)
        self.profileSignUpImage = tempImage
        let imageData = tempImage.jpegData(compressionQuality: 0.8)
        print(imageData)
        self.signUpImage = imageData
//        if let imageData = tempImage.jpegData(compressionQuality: 0.8) {
//            // Convert image data to base64-encoded string
//            let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
//
//            // Now 'base64String' contains the base64 representation of the image data
//            // You can send this string to the backend
//
//            // Store the base64 string if needed
//            self.signUpImageBase64String = base64String
//            print(signUpImageBase64String)
//        }
        
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


extension signUpVC: InterestVCDelegate{
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
extension signUpVC: SignUpVMObserver{
    func observerSignUpApi() {
//        self.popVC()
        let vc = LoginVC()
        self.pushViewController(vc, true)
    }
    
    
}

//extension signUpVC : UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return selectedInterests.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
//        return cell
//    }
//
//}
//


