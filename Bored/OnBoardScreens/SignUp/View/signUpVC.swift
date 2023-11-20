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
  
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        setCollectionViewDelegates()
        
    }
    
    func setCollectionViewDelegates(){
//        interestsCollectionView.delegate = self
//        interestsCollectionView.dataSource = self
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
    
    @IBAction func checkUncheckAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.setBackgroundImage(UIImage(named: "ic_uncheck"), for: .selected)
        
    }
    
    @IBAction func signInAction(_ sender: UIButton) {

        
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc = LoginVC()
        self.navigationController?.navigationBar.isHidden = true
        self.pushViewController(vc, true)
    }
    
    @IBAction func interestCollectionButton(_ sender: UIButton) {
        let vc = InterestVC()
    
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: {
            vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
        })
    }

    
    
}


extension signUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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


