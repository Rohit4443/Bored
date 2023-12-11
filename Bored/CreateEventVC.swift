//
//  CreateEventVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit
import PhotosUI

class CreateEventVC: UIViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var eventsTagCollectionView: UICollectionView!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var showUploadPhotosCollectionView: UICollectionView!
    @IBOutlet weak var createEventTitleLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleUnderlineLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var backButtonWidthContraints: NSLayoutConstraint!
    
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    
    //MARK: - Variables -
    var imageArray = [UIImage]()
    let maxImageLimit = 10
    var comeFrom: String?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        createTimePickers()
        createDatePicker()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if comeFrom == "EditEvent"{
            createButton.setTitle("Save", for: .normal)
            createEventTitleLabel.text = "Edit Event"
            titleUnderlineLabel.isHidden = true
            backButton.isHidden = false
            backButtonHeightContraint.constant = 30
            backButtonWidthContraints.constant = 30
            
            
        }else{
            createButton.setTitle("Create", for: .normal)
            createEventTitleLabel.text = "Create Event"
            backButton.isHidden = true
            backButtonHeightContraint.constant = 0
            backButtonWidthContraints.constant = 0
        }
    }
    
    //MARK: - CustomFunction -

    func createDatePicker(){
        createDatePicker(for: startDateTF)
        createDatePicker(for: endDateTF)
    }
    
    func createDatePicker(for textField: UITextField) {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .date
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(DatePickerValueChanged), for: .valueChanged)
        textField.inputView = timePicker
    }
    
    @objc func DatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        if startDateTF.isFirstResponder {
            startDateTF.text = dateFormatter.string(from: sender.date)
        } else if endDateTF.isFirstResponder {
            endDateTF.text = dateFormatter.string(from: sender.date)
        }
    }
    
    
    func createTimePickers() {
        createTimePicker(for: startTimeTextField)
        createTimePicker(for: endTimeTextField)
    }
    
    func createTimePicker(for textField: UITextField) {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        textField.inputView = timePicker
    }
    
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        if startTimeTextField.isFirstResponder {
            startTimeTextField.text = dateFormatter.string(from: sender.date)
        } else if endTimeTextField.isFirstResponder {
            endTimeTextField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    
    
    func setCollectionViewDelegates(){
        showUploadPhotosCollectionView.delegate = self
        showUploadPhotosCollectionView.dataSource = self
        showUploadPhotosCollectionView.register(UINib(nibName: "UploadImagesCVCell", bundle: nil), forCellWithReuseIdentifier: "UploadImagesCVCell")
    }
    
    
    
    //MARK: - IBAction -
    @IBAction func createAction(_ sender: UIButton) {
       
    }
    
    @IBAction func eventTagsAction(_ sender: UIButton) {
        let vc = InterestEventTags()
        vc.comefrom = "eventTags"
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
        
    }
    
    @IBAction func locationAction(_ sender: UIButton) {
        let vc = SelectLocationVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}

//MARK: - ImagePicker -
extension CreateEventVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        return
                    }
                    
                    if let image = object as? UIImage {
                        self.imageArray.append(image)
                        
                        DispatchQueue.main.async {
                            self.showUploadPhotosCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}



//MARK: - CollectionView Delegate and DataSource -
extension CreateEventVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == imageArray.count && imageArray.count < maxImageLimit {
            var config = PHPickerConfiguration()
            config.selectionLimit = maxImageLimit - imageArray.count
            let phpicker = PHPickerViewController(configuration: config)
            phpicker.delegate = self
            self.present(phpicker, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(imageArray.count + 1, maxImageLimit)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImagesCVCell", for: indexPath) as? UploadImagesCVCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item < imageArray.count {
            cell.addPhotoImage.contentMode = .scaleAspectFill
            cell.addPhotoImage.image = imageArray[indexPath.item]
            cell.deletePhotoButton.isHidden = false
            cell.deleteButtonAction = { [weak self] in
                self?.deleteImage(at: indexPath)
            }
        } else {
            cell.addPhotoImage.contentMode = .scaleAspectFit
            cell.addPhotoImage.image = UIImage(named: "ic_addPhoto")
            cell.deletePhotoButton.isHidden = true
        }
        
        
        
        return cell
    }
    
    func deleteImage(at indexPath: IndexPath) {
        guard indexPath.item < imageArray.count else {
            return
        }
        
        
        imageArray.remove(at: indexPath.item)
        
        
        showUploadPhotosCollectionView.performBatchUpdates({
            
            showUploadPhotosCollectionView.deleteItems(at: [indexPath])
        }) { [weak self] _ in
            
            self?.showUploadPhotosCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 138)
        
    }
}
