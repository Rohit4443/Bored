//
//  MapVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    @IBOutlet weak var mapUserCollectionView: UICollectionView!
    
    //MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapVisibiltyLabel: UILabel!
    
    @IBOutlet weak var toggleBtn: UISwitch!
    
    var viewModel: MapVM?
    var gender: String?
    let locationManager = CLLocationManager()
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapAnnotation()
        setCollectionViewDelegate()
        setupLocationManager()
//        setViewModel()
        
//        print(UserDefaultsCustom.getUserData()?.is_private)
//
//        if UserDefaultsCustom.getUserData()?.is_private == "1"{
//            toggleBtn.isOn = false
//            mapView.isHidden = true
//            mapUserCollectionView.isHidden = true
//        }else{
//            toggleBtn.isOn = true
//            mapView.isHidden = false
//            mapUserCollectionView.isHidden = false
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViewModel()
        print(UserDefaultsCustom.getUserData()?.is_private)
        
        if UserDefaultsCustom.getUserData()?.is_private == "1"{
            toggleBtn.isOn = false
            mapView.isHidden = true
            mapUserCollectionView.isHidden = true
        }else{
            toggleBtn.isOn = true
            mapView.isHidden = false
            mapUserCollectionView.isHidden = false
        }
    }
    
    //MARK: - CustomFunction -
    

    func getPlaceNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                print("Place Details:")
                print("Name: \(placemark.name ?? "N/A")")
                print("Thoroughfare: \(placemark.thoroughfare ?? "N/A")")
                print("Locality: \(placemark.locality ?? "N/A")")
                print("Country: \(placemark.country ?? "N/A")")
                // Access other properties as needed
            } else {
                print("No placemark available for the provided coordinates")
            }
        }
    }


    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Set desired accuracy
        locationManager.requestWhenInUseAuthorization() // Request location authorization
        locationManager.startUpdatingLocation() // Start receiving location updates
    }

    
    func setMapAnnotation(){
        
        mapView.mapType = MKMapType.standard
        
        let location = CLLocationCoordinate2D(latitude: 30.7046,longitude: 76.7179)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        mapView.addAnnotation(annotation)
    }
    
    func setCollectionViewDelegate(){
        mapUserCollectionView.delegate = self
        mapUserCollectionView.dataSource = self
        mapUserCollectionView.register(UINib(nibName : "MapCVCell" , bundle: nil), forCellWithReuseIdentifier: "MapCVCell")
    }
    
    func setViewModel(){
        self.viewModel = MapVM(observer: self)
        self.viewModel?.mapListingApi(lat: "30.7376748", long: "76.7421137")
    }
    
    func calculateAge(birthdate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
        let age = ageComponents.year ?? 0
        
        return age
    }

    
    //MARK: - IBAction -
    @IBAction func toggleAction(_ sender: UISwitch) {
        if sender.isOn {
            viewModel?.mapVisibilityApi(isPrivate: "0")
            mapView.isHidden = false
            mapUserCollectionView.isHidden = false
        } else {
            viewModel?.mapVisibilityApi(isPrivate: "1")
            mapView.isHidden = true
            mapUserCollectionView.isHidden = true
            
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("Latitude: \(latitude), Longitude: \(longitude)")
        // Call the function with your coordinates
        getPlaceNameFromCoordinates(latitude: latitude, longitude: longitude)
        // Use the latitude and longitude values as needed
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
}

extension MapVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
        return viewModel?.mapListingData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCVCell", for: indexPath) as! MapCVCell
        cell.userImage.setImage(image: viewModel?.mapListingData[indexPath.row].image)
        cell.userName.text = viewModel?.mapListingData[indexPath.row].name
        let date = viewModel?.mapListingData[indexPath.row].dob ?? ""
        print(date)
        // Example birthdate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Date format matching your DOB string
        let dobString = date // Replace this with your DOB string
        let dobDate = dateFormatter.date(from: dobString)!
        print(dobDate)
        // Calculate age
        let age = calculateAge(birthdate: dobDate)
        print("Age: \(age)")
        if viewModel?.mapListingData[indexPath.row].gender == "1"{
            self.gender = "Male"
        }else{
            self.gender = "Female"
        }
        
        cell.userAge.text = "\(age)\(" Yrs, ")\(self.gender ?? "")"
        cell.interestArray = viewModel?.mapListingData[indexPath.row].interestsData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 1.1
                      ,height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlaceDetailVC()
        vc.comFromSearch = false
        vc.detail = viewModel?.mapListingData[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
        }
    }


extension MapVC: MapVMObserver{
    func mapVisisbility(isPrivate: String) {
        print(isPrivate)
    }
  
    func observerMapListing() {
        mapUserCollectionView.reloadData()
    }
    
    
}
