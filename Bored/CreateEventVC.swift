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
    let maxImageLimit = 4
    var comeFrom: String?
    var viewModel: CreateEventVM?
    var interestItems: String?
    var selectedInterestedItem: [String]?
    var otherInterest: String?
    var interestID: String?
    var eventDetail: HomeDetailData?
    var comeToEdit: Bool?
    var eventId: String?
    var lat: String?
    var long: String?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        createTimePickers()
        createDatePicker()
        setViewModel()
        setInterestCollectionViewDelegates()
        print(eventDetail)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if comeFrom == "EditEvent"{
            createButton.setTitle("Save", for: .normal)
            createEventTitleLabel.text = "Edit Event"
            titleUnderlineLabel.isHidden = true
            backButton.isHidden = false
            backButtonHeightContraint.constant = 30
            setDataWhenComesToEditScreen()
        }else{
            createButton.setTitle("Create", for: .normal)
            createEventTitleLabel.text = "Create Event"
            backButton.isHidden = true
            backButtonHeightContraint.constant = 0
            backButtonWidthContraints.constant = 0
        }
    }
    
    //MARK: - CustomFunction -

    func setViewModel(){
        self.viewModel = CreateEventVM(observer: self)
    }
    func setInterestCollectionViewDelegates(){
        eventsTagCollectionView.delegate = self
        eventsTagCollectionView.dataSource = self
        eventsTagCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
       
    }
    func setDataWhenComesToEditScreen(){
        self.eventId = eventDetail?.event_id
        self.eventNameTextField.text = eventDetail?.title
        self.descriptionTextView.text = eventDetail?.description
        self.startDateTF.text = eventDetail?.start_date
        self.endDateTF.text = eventDetail?.end_date
        self.startTimeTextField.text = eventDetail?.start_time
        self.endTimeTextField.text = eventDetail?.end_time
        self.locationTextField.text = eventDetail?.location
        self.lat = eventDetail?.latitude
        self.long = eventDetail?.longitude
//        self.interestID = eventDetail?.event_tags
        print(imageArray)
    }
    
    func createDatePicker(){
        createDatePicker(for: startDateTF)
        createDatePicker(for: endDateTF)
    }
    
    func createDatePicker(for textField: UITextField) {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .date
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.minimumDate = Date()
        timePicker.addTarget(self, action: #selector(DatePickerValueChanged), for: .valueChanged)
        textField.inputView = timePicker
    }
    
    @objc func DatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if startDateTF.isFirstResponder {
            startDateTF.text = dateFormatter.string(from: sender.date)
        } else if endDateTF.isFirstResponder {
            let selectedEndDate = sender.date
            let selectedStartDate = dateFormatter.date(from: startDateTF.text ?? "") ?? Date()
            
            if selectedEndDate < selectedStartDate {
//                endDateTF.text = dateFormatter.string(from: selectedStartDate)
                // You can also display an alert or error message to the user
                Singleton.showMessage(message: "End date cannot be earlier than start date", isError: .error)
            } else {
                endDateTF.text = dateFormatter.string(from: selectedEndDate)
            }
            
//            endDateTF.text = dateFormatter.string(from: sender.date)
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
        timePicker.locale = Locale(identifier: "en_US_POSIX")
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        textField.inputView = timePicker
    }
    
    
    @objc func timePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "h:mm a"
        if startTimeTextField.isFirstResponder {
            startTimeTextField.text = dateFormatter.string(from: sender.date)
           
        } else if endTimeTextField.isFirstResponder {
            
            print("\(endTimeTextField.text)\(startTimeTextField.text)")
            let endTime = sender.date
            let startTime = dateFormatter.date(from: startTimeTextField.text ?? "") ?? Date()
            // Get calendar and components to compare time
            let calendar = Calendar.current
            let startComponents = calendar.dateComponents([.hour, .minute], from:  startTime)
            let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
            
            if let startHour = startComponents.hour, let startMinute = startComponents.minute,
               let endHour = endComponents.hour, let endMinute = endComponents.minute {

                if (startHour > endHour) {
                    showMessage(message: "End time should be after start time", isError: .error)
                }else{
                    endTimeTextField.text = dateFormatter.string(from: sender.date)
                }
                
                
                //            endTimeTextField.text = dateFormatter.string(from: sender.date)
            }
        }
        
    }
    
    func setCollectionViewDelegates(){
        showUploadPhotosCollectionView.delegate = self
        showUploadPhotosCollectionView.dataSource = self
        showUploadPhotosCollectionView.register(UINib(nibName: "UploadImagesCVCell", bundle: nil), forCellWithReuseIdentifier: "UploadImagesCVCell")
    }
    
    func convertImagesToData(_ images: [UIImage]) -> [Data] {
        var imageDataArray: [Data] = []
        
        for image in images {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                imageDataArray.append(imageData)
            }
        }
        
        return imageDataArray
    }
    
    func poptoSpecificVC(viewController : Swift.AnyClass){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController.isKind(of: viewController) {
                self.navigationController!.popToViewController(aViewController, animated: false)
                break;
            }
        }
    }
    
    //MARK: - IBAction -
    @IBAction func createAction(_ sender: UIButton) {
        
        print("\(imageArray.count)\(imageArray)")
        let imageDataArray = self.convertImagesToData(imageArray)
        print(imageDataArray)

        
        let isValidEventName = Validator.validateName(name: eventNameTextField.text ?? "", message: "Please enter Event Name")
        let isValidDescrip = Validator.validateDescription(words: descriptionTextView.text ?? "")
        let isValidStartDate = Validator.validateName(name: startDateTF.text ?? "", message: "Please enter start date")
        let isValidEndDate = Validator.validateName(name: endDateTF.text ?? "", message: "Please enter end date")
        let isValidStartTime = Validator.validateName(name: startTimeTextField.text ?? "", message: "Please enter start time")
        let isValidEndTime = Validator.validateName(name: endTimeTextField.text ?? "", message: "Please enter start date")
        let isValidInterestCollectionView = Validator.validateCollectionView(collectionView: eventsTagCollectionView)
        let isValidLocation = Validator.validateName(name: endTimeTextField.text ?? "", message: "Please select location")
 
        
        guard isValidEventName.0 == true else {
            Singleton.showMessage(message: isValidEventName.1, isError: .error)
            return
        }
        guard isValidDescrip.0 == true else {
            Singleton.showMessage(message: isValidDescrip.1, isError: .error)
            return
        }
        guard isValidStartDate.0 == true else {
            Singleton.showMessage(message: isValidStartDate.1, isError: .error)
            return
        }
        guard isValidEndDate.0 == true else {
            Singleton.showMessage(message: isValidEndDate.1, isError: .error)
            return
        }
        guard isValidStartTime.0 == true else {
            Singleton.showMessage(message: isValidStartTime.1, isError: .error)
            return
        }
        guard isValidEndTime.0 == true else {
            Singleton.showMessage(message: isValidEndTime.1, isError: .error)
            return
        }
        
        guard isValidInterestCollectionView.0 == true else {
            Singleton.showMessage(message: isValidInterestCollectionView.1, isError: .error)
            return
        }
        guard isValidLocation.0 == true else {
            Singleton.showMessage(message: isValidLocation.1, isError: .error)
            return
        }
        if comeFrom == "EditEvent"{
            let imageDataArray = self.convertImagesToData(imageArray)
            print(imageDataArray)
            print("\(imageDataArray)\(interestID)\(eventId)")
            if imageDataArray.count == 0{
                showMessage(message: "Event Images are mandatory to be added", isError: .error)
            }else{
                viewModel?.editEventApi(title: eventNameTextField.text ?? "" , description: descriptionTextView.text ?? "", startDate: startDateTF.text ?? "", endDate: endDateTF.text ?? "", endTime: endTimeTextField.text ?? "", startTime: startTimeTextField.text ?? "", location: locationTextField.text ?? "", latitude: self.lat ?? "", longitude: self.long ?? "", eventTag: self.interestID ?? "", files: imageDataArray, thumbImage: "", type: "1", eventId: eventId ?? "")
            }
        }else{
            if imageDataArray.count == 0{
                showMessage(message: "Event Images are mandatory to be added", isError: .error)
            }else{
                viewModel?.createEventApi(title:eventNameTextField.text ?? "" ,description: descriptionTextView.text ?? "", startDate: startDateTF.text ?? "", endDate: endDateTF.text ?? "", endTime: endTimeTextField.text ?? "", startTime: startTimeTextField.text ?? "", location: locationTextField.text ?? "", latitude: self.lat ?? "", longitude: self.long ?? "", eventTag: self.interestID ?? "", files: imageDataArray, thumbImage: "", type: "1")
            }
        }
   
    }
    
    @IBAction func eventTagsAction(_ sender: UIButton) {
        let vc = InterestEventTags()
        vc.comefrom = "eventTags"
        vc.delegate = self
        vc.selectedArray = eventDetail?.event_tags_data//viewModel?.interestData
        vc.alredySelectedInterest = interestItems
        vc.alreadySelectedID = interestID
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
        
    }
    
    @IBAction func locationAction(_ sender: UIButton) {
        let vc = SelectLocationVC()
        vc.delegate = self
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
//        if comeFrom == "EditEvent"{
//            let images = eventDetail?.files?.count ?? 0
//            if indexPath.item == images && images < maxImageLimit {
//                var config = PHPickerConfiguration()
//                config.selectionLimit = maxImageLimit - images
//                let phpicker = PHPickerViewController(configuration: config)
//                phpicker.delegate = self
//                self.present(phpicker, animated: true, completion: nil)
//            }
//        }else{
            if indexPath.item == imageArray.count && imageArray.count < maxImageLimit {
                var config = PHPickerConfiguration()
                config.selectionLimit = maxImageLimit - imageArray.count
                let phpicker = PHPickerViewController(configuration: config)
                phpicker.delegate = self
                self.present(phpicker, animated: true, completion: nil)
//            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.eventsTagCollectionView{
            if comeFrom == "EditEvent"{
                if comeToEdit == false{
                    return selectedInterestedItem?.count ?? 0
                }else{
                    return eventDetail?.event_tags_data?.count ?? 0
                }
            }else{
                return selectedInterestedItem?.count ?? 0
            }
        }else{
//            if comeFrom == "EditEvent"{
//                let images = eventDetail?.files?.count ?? 0
//                return min(images + 1, maxImageLimit)
//            }else{
                return min(imageArray.count + 1, maxImageLimit)
//            }
           
        }
 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.eventsTagCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
            if comeFrom == "EditEvent"{
                if comeToEdit == false{
                    cell.interestNameButton.setTitle(selectedInterestedItem?[indexPath.row], for: .normal)
                    
                }else{
                    cell.interestNameButton.setTitle(eventDetail?.event_tags_data?[indexPath.row].interest_name, for: .normal)
                }
            }else{
                cell.interestNameButton.setTitle(selectedInterestedItem?[indexPath.row], for: .normal)
            }
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImagesCVCell", for: indexPath) as? UploadImagesCVCell else {
                return UICollectionViewCell()
            }
//            if comeFrom == "EditEvent"{
//                let images = eventDetail?.files?.count ?? 0
//                if indexPath.item < images{
//                    cell.addPhotoImage.contentMode = .scaleAspectFill
//                    cell.addPhotoImage.setImage(image: eventDetail?.files?[indexPath.item].files)
//                    cell.deletePhotoButton.isHidden = false
//                    let array = eventDetail?.files
//                    print(array?.count)
//                    let imageArray = eventDetail?.files?[indexPath.item].files
//                    print(imageArray)
//
//                    cell.deleteButtonAction = { [weak self] in
//                        self?.deleteImage(at: indexPath)
//                    }
//                } else {
//                    cell.addPhotoImage.contentMode = .scaleAspectFit
//                    cell.addPhotoImage.image = UIImage(named: "ic_addPhoto")
//                    cell.deletePhotoButton.isHidden = true
//                }
//            }else{
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
//            }
            return cell
        }
        
    }
    
    func deleteImage(at indexPath: IndexPath) {
        
//        if comeFrom == "EditEvent"{
//            guard let imagesCount = eventDetail?.files?.count, indexPath.item < imagesCount else {
//                return
//            }
//            eventDetail?.files?.remove(at: indexPath.item)
//
//            showUploadPhotosCollectionView.performBatchUpdates({
//                showUploadPhotosCollectionView.deleteItems(at: [indexPath])
//            }) { [weak self] _ in
//                self?.showUploadPhotosCollectionView.reloadData()
//            }
//        }else{
            guard indexPath.item < imageArray.count else {
                return
            }
            
            imageArray.remove(at: indexPath.item)
            
            showUploadPhotosCollectionView.performBatchUpdates({
                
                showUploadPhotosCollectionView.deleteItems(at: [indexPath])
            }) { [weak self] _ in
                
                self?.showUploadPhotosCollectionView.reloadData()
            }
//        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.eventsTagCollectionView{
            if comeFrom == "EditEvent"{
                if comeToEdit == false{
                    let text = selectedInterestedItem?[indexPath.row] ?? ""
                    let width = UILabel.textWidth(font: UIFont.setCustom(.Poppins_Regular, 10), text: text)
                    return CGSize(width: (width + 72) , height: collectionView.frame.size.height)
                }else{
                    let text = eventDetail?.event_tags_data?[indexPath.row].interest_name ?? ""
                    let width = UILabel.textWidth(font: UIFont.setCustom(.Poppins_Regular, 10), text: text)
                    return CGSize(width: (width + 72) , height: collectionView.frame.size.height)
                }
               
            }else{
                let text = selectedInterestedItem?[indexPath.row] ?? ""
                let width = UILabel.textWidth(font: UIFont.setCustom(.Poppins_Regular, 10), text: text)
                return CGSize(width: (width + 72) , height: collectionView.frame.size.height)
            }
          
        }else{
            return CGSize(width: 100, height: 138)
        }
        
    }
}
extension CreateEventVC: CreateEventVMObserver{
    func observerEditEvent() {
        poptoSpecificVC(viewController: MyEventVC.self)
    }
    
    func observerCreateEvent() {
        if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0 // Switch to the first tab
                if let firstTabVC = tabBarController.viewControllers?[0] as? HomeVC {
                    firstTabVC.popToSpecificViewController()
                }
            }
        
    }
   
}
 
extension CreateEventVC: InterestEventTagsDelegate{
   
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
        print(self.interestID)
        self.comeToEdit = comeToEdit
        print(self.comeToEdit)
        eventsTagCollectionView.reloadData()
    }
 
    
}
extension CreateEventVC: AddLocationVCDelegate{
    func setLocation(text: String, lat: Double, long: Double, address: String, country: String) {
        DispatchQueue.main.async {
            self.locationTextField.text = address
            self.lat = "\(lat)"
            self.long = "\(long)"
        }
       
        
    }
    
    
}
