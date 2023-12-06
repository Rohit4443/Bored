//
//  FilterVC.swift
//  Bored
//
//  Created by Dr.mac on 27/10/23.
//

import UIKit
import MultiSlider
import GoogleMaps
import GooglePlaces
import CoreLocation

class FilterVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var slider: MultiSlider!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var maxValue: UILabel!
    var arrayName = ["Baking","Cooking","Dance","Swing Dancing","Picnics","Hiking","Rock Climbing","Pickleball","Plants","Yoga","Museums","Video Game","Fitness","BBQ","Singing","Festivals","Sports","Camping","Concerts","Trivia",]
    
  //  var completion : (() -> Void)? = nil
    var arraySelectedValue:[String] = []
    let locationManager = CLLocationManager()
    var lat: String?
    var long: String?
    var viewModel: InterestVM?
    var interestData: String?
    var selectedArray: [InterestsDatum]?
    var arraySelectedID:[String] = []
  //  var selectedInterest: String?
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionViewDelegates()
        slider.valueLabelPosition = .left
        slider.valueLabelPosition = .top
        slider.isValueLabelRelative = true
        slider.valueLabelColor = .black
        filterCollectionView.collectionViewLayout = createCenterAlignedLayout()
        getUserLocation()
        setSlider()
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = InterestVM(observer: self)
        self.viewModel?.getInterest()
        self.interestData = UserDefaultsCustom.getProfileData()?.interests
        print(self.interestData)
        if let selectedInterests = selectedArray {
            arraySelectedID = selectedInterests.map { $0.interest_id ?? "" }
        }
        
    }
    
    func setSlider() {
        slider.minimumValue = 0.0
        slider.maximumValue = 200.0
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        updateLabels(min: slider.value[0], max: slider.value[1])
        minValue.text = "0 miles"//"\(slider.value[0])"
        maxValue.text = "0 miles"
    }

    @objc func sliderValueChanged(_ slider: MultiSlider) {
        updateLabels(min: slider.value[0], max: slider.value[1])
    }

    func updateLabels(min: CGFloat, max: CGFloat) {
        minValue.text = "\(Int(min)) miles"
        maxValue.text = "\(Int(max)) miles"
        print("\(minValue.text)\(maxValue.text)")
    }

    
    func getUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    //MARK: - CustomFunction -
    func setCollectionViewDelegates(){
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(UINib(nibName: "interestCVCell", bundle: nil), forCellWithReuseIdentifier: "interestCVCell")
        locationTF.delegate = self
        locationTF.addTarget(self, action: #selector(locationPicker), for: .valueChanged)
    }

    
    @objc func locationPicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = [.addressComponents, .coordinate, .formattedAddress]
        autocompleteController.placeFields = fields
        present(autocompleteController, animated: true, completion: nil)
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = [.addressComponents, .coordinate, .formattedAddress]
        autocompleteController.placeFields = fields
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func getSelectedInterests() -> [String] {
        var selectedInterests: [String] = []
        
        guard let interestData = viewModel?.interestData else {
            return selectedInterests
        }
        
        for (index, interest) in interestData.enumerated() {
            if let interestName = interest.interest_name,
               arraySelectedValue.contains(interestName),
               let cell = filterCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? interestCVCell,
               cell.backgroundCellView.borderColor == UIColor.black {
                selectedInterests.append(interestName)
            }
        }
        
        return selectedInterests
    }

    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        print(arraySelectedValue.count)
    }
}


//MARK: - CollectionView Delegate and DataSource -
extension FilterVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.interestData.count ?? 0
//        return arrayName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCVCell", for: indexPath) as! interestCVCell
        
        // Get the selected interest IDs from UserDefaults
        if let selectedInterestIDs = UserDefaultsCustom.getProfileData()?.interests {
            // Retrieve the ID for the current interest cell
            if let interestId = viewModel?.interestData[indexPath.row].interest_id {
                if selectedInterestIDs.contains(interestId) {
                    
                    cell.backgroundCellView.setBorder(.black, corner: 20, 1)
                    cell.interestNameButton.setTitleColor(.black, for: .normal)
                } else {
                    cell.backgroundCellView.setBorder(.lightGray, corner: 20, 1)
                    cell.interestNameButton.setTitleColor(.lightGray, for: .normal)
                }
            }
        }
        cell.interestNameButton.setTitle(viewModel?.interestData[indexPath.row].interest_name, for: .normal)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //            return CGSize(width: arrayName[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]).width + 55, height: 51)
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedInterest = viewModel?.interestData[indexPath.item].interest_name ?? ""
        
        if let cell = collectionView.cellForItem(at: indexPath) as? interestCVCell {
            if arraySelectedValue.contains(selectedInterest) {
                arraySelectedValue.removeAll { $0 == selectedInterest }
            } else {
                arraySelectedValue.append(selectedInterest)
            }
            
            let isSelected = arraySelectedValue.contains(selectedInterest)
            cell.backgroundCellView.borderColor = isSelected ? .black : .systemGray
            cell.interestNameButton.setTitleColor(isSelected ? .black : .systemGray, for: .normal)
            
            // Get all the selected interests whenever a selection is made
            let selectedInterests = getSelectedInterests()
            // Use the selected interests as needed
            print(selectedInterests)
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedInterest = viewModel?.interestData[indexPath.item].interest_name ?? ""
//
//        if let cell = collectionView.cellForItem(at: indexPath) as? interestCVCell {
//
//            if arraySelectedValue.contains(selectedInterest) {
//                arraySelectedValue.removeAll { $0 == selectedInterest }
//            } else {
//                arraySelectedValue.append(selectedInterest)
//            }
//
//            let isSelected = arraySelectedValue.contains(selectedInterest)
//            cell.backgroundCellView.borderColor = isSelected ? .black : .systemGray
//            cell.interestNameButton.setTitleColor(isSelected ? .black : .systemGray, for: .normal)
//
//        }
//    }
    
}

extension FilterVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let placeLocation = locations.last else {
            return
        }
        self.locationManager.stopUpdatingLocation()
        
        // Use the location's latitude and longitude
        let latitude = placeLocation.coordinate.latitude
        let longitude = placeLocation.coordinate.longitude
        
        // Now you have the current latitude and longitude
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        
        self.lat = "\(placeLocation.coordinate.latitude)"
        self.long = "\(placeLocation.coordinate.longitude)"
        
        // Use reverse geocoding to get the place name
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print("Error in reverse geocoding: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Here you can access the place name and other address information
            if let placeName = placemark.name {
                print("Place Name: \(placeName)")
            }
            if let city = placemark.locality {
                print("City: \(city)")
//                self.cityName = city
//                self.locationBtn.setTitle(self.cityName, for: .normal)
            }
            
//            self.checkLocationServices()
#if targetEnvironment(simulator)
//        self.viewModel?.homeDispensaryListApi(lat: "30.7046", long: "76.7179", search: "")
#else
            
#endif
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization")
    }
}
extension FilterVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.lat = "\(place.coordinate.latitude)"
        self.long = "\(place.coordinate.longitude)"
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: place.coordinate.latitude, longitude:  place.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                
                if let city = placemark.locality,
                   let name = placemark.name {
                    print(city)
//                    self.locationBtn.setTitle("\(name) \(city)", for: .normal)
                }
            }
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension FilterVC: InterestVMObserver{
    func getListing() {
        if viewModel?.interestData.count ?? 0 > 0 {
            self.filterCollectionView.backgroundView = nil
        } else {
            self.filterCollectionView.setBackgroundView(message: "No Data Found")
        }
        self.filterCollectionView.reloadData()
    }
    
    
}
