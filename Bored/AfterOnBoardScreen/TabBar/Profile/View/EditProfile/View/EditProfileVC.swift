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
    
    //MARK: - Variables -
   
    var imagePickerController = UIImagePickerController()
  
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
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
    
   
    
    @IBAction func saveAction(_ sender: UIButton) {

        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    
    @IBAction func interestCollectionButton(_ sender: UIButton) {
        let vc = InterestEventTags()
        self.pushViewController(vc, true)
        
    
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
