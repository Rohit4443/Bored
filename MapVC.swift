//
//  MapVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

class MapVC: UIViewController {
    @IBOutlet weak var mapUserCollectionView: UICollectionView!
    
    //MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapVisibiltyLabel: UILabel!
    
    @IBOutlet weak var toggleBtn: UISwitch!
    
    var latitude: Double?
    var longitude: Double?
    var viewModel: MapVM?
    var gender: String?
    var locationManager: CLLocationManager?
    var locationUpdateTimer: Timer?
    var apiCallDelay: TimeInterval = 3.0
    var hasHitAPI = false
    var userName = String()
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
//        setMapAnnotation()
        setCollectionViewDelegate()
        mapUserCollectionView.isHidden = true
        setViewModel()
        mapView.delegate = self
        
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
        setupLocationManager()
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
    
//
//    func getPlaceNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        let geocoder = CLGeocoder()
//
//        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            if let error = error {
//                print("Reverse geocoding failed with error: \(error.localizedDescription)")
//                return
//            }
//
//            if let placemark = placemarks?.first {
//                print("Place Details:")
//                print("Name: \(placemark.name ?? "N/A")")
//                print("Thoroughfare: \(placemark.thoroughfare ?? "N/A")")
//                print("Locality: \(placemark.locality ?? "N/A")")
//                print("Country: \(placemark.country ?? "N/A")")
//                // Access other properties as needed
//            } else {
//                print("No placemark available for the provided coordinates")
//            }
//        }
//    }
//
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest // Set desired accuracy
        locationManager?.requestWhenInUseAuthorization() // Request location authorization
        locationManager?.startUpdatingLocation() // Start receiving location updates
    }
    
    
//    func startLocationUpdateTimer() {
//        locationUpdateTimer = Timer.scheduledTimer(timeInterval: apiCallDelay, target: self, selector: #selector(handleLocationUpdate), userInfo: nil, repeats: true)
//    }
//
//    @objc func handleLocationUpdate() {
//        guard let location = locationManager?.location else { return }
//        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
//        // Hit the API with the coordinates
//        if !hasHitAPI {
//            let lat = "\(location.coordinate.latitude)"
//            let long = "\(location.coordinate.longitude)"
//            self.viewModel?.mapListingApi(lat: lat, long: long)
//            hasHitAPI = true
//        }
//    }
//
    
    
    
    //
    //    func setMapAnnotation(){
    //        mapView.mapType = MKMapType.standard
    //
    //        let location = CLLocationCoordinate2D(latitude: 30.7376748,longitude: 76.7421137 )
    //
    //        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    //        let region = MKCoordinateRegion(center: location, span: span)
    //        mapView.setRegion(region, animated: true)
    //
    //        let annotation = MKPointAnnotation()
    //        annotation.coordinate = location
    //
    //        mapView.addAnnotation(annotation)
    //    }
    //
    
//    func setMapAnnotation() {
//        mapView.mapType = .standard
//
//        // Assuming mapListingData is your array of MapListingData fetched from your model
//        if let mapListingData = viewModel?.mapListingData, !mapListingData.isEmpty {
//            var annotations: [MKPointAnnotation] = []
//
//            for data in mapListingData {
//                if let latitudeStr = data.latitude, let longitudeStr = data.longitude,
//                   let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
//                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = location
//                    annotation.title = data.name // Set the title with data from your model
//                    // annotation.subtitle = "Any Subtitle" // Set subtitle if needed
//
//                    annotations.append(annotation)
//                    print(annotations.count)
//                }
//            }
//            mapView.addAnnotations(annotations)
//            mapView.showAnnotations(annotations, animated: true)
//            printAnnotationsCoordinates()
//        } else {
//            print("No map data available")
//        }
//    }
//
//    func printAnnotationsCoordinates() {
//        for annotation in mapView.annotations {
//            print("Annotation Title: \(annotation.title ?? "")")
//            print("Latitude: \(annotation.coordinate.latitude), Longitude: \(annotation.coordinate.longitude)")
//        }
//    }
//
    
    func setCollectionViewDelegate(){
        mapUserCollectionView.delegate = self
        mapUserCollectionView.dataSource = self
        mapUserCollectionView.register(UINib(nibName : "MapCVCell" , bundle: nil), forCellWithReuseIdentifier: "MapCVCell")
    }
    
    func setViewModel(){
        hasHitAPI = false
        self.viewModel = MapVM(observer: self)
        let lat = UserDefaultsCustom.latitude
        let long = UserDefaultsCustom.longitude
        self.viewModel?.mapListingApi(lat: lat ?? "", long: long ?? "")
        //        self.viewModel?.mapListingApi(lat: "30.7376748", long: "76.7421137")
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
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // Start the timer after receiving the initial location
//        startLocationUpdateTimer()
//
//        // Stop the location updates to prevent continuous calls to handleLocationUpdate
//        locationManager?.stopUpdatingLocation()
//
//
//
//        //        guard let location = locations.last else { return }
//        //        let latitude = location.coordinate.latitude
//        //        let longitude = location.coordinate.longitude
//        //        print("Latitude: \(latitude), Longitude: \(longitude)")
//        //        self.latitude = latitude
//        //        self.longitude = longitude
//        //        //Hit api
//        //        let lat = "\(latitude)"
//        //        let long = "\(longitude)"
//        //        self.viewModel?.mapListingApi(lat: lat, long: long)
//
//        // Call the function with your coordinates
//        //        getPlaceNameFromCoordinates(latitude: latitude, longitude: longitude)
//        // Use the latitude and longitude values as needed
//    }
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
    
    
    //MARK: - setMapRegion
    func setMapRegion(withIsAnnSelc isAnnSelc: Bool) {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        let selcAnn = self.mapView.selectedAnnotations
        self.mapView.removeAnnotations(selcAnn)
        
        for i in viewModel?.mapListingData ?? [] {
            let annotation = MKPointAnnotation()
            let doubleValue = Double(i.latitude ?? "")
            let doubleValues = Double(i.longitude ?? "")
            self.userName = i.name ?? ""
            
            print("latitude",doubleValue ?? 0.0)
            print("longitude",doubleValues ?? 0.0)
            let fixedCoord = CLLocationCoordinate2D(latitude:doubleValue ?? 0.0, longitude:doubleValues ?? 0.0)
            let map_region = MKCoordinateRegion(center: fixedCoord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            let mk_ann = MKPointAnnotation()
            mk_ann.coordinate = fixedCoord
            self.mapView.addAnnotation(mk_ann)
            self.mapView.setRegion(map_region, animated: true)
            
            if isAnnSelc {
                self.mapView.selectAnnotation(mk_ann, animated: true)
            } else {}
        }
    }
    
}

extension MapVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return 4
        return viewModel?.mapListingData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCVCell", for: indexPath) as! MapCVCell
        cell.userImage.setImage(image: viewModel?.mapListingData[indexPath.row].image,placeholder: UIImage(named: "placeholder"))
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
        
        DispatchQueue.main.async { self.setMapRegion(withIsAnnSelc: true) }
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
//        setMapAnnotation()
        mapUserCollectionView.reloadData()
    }
    
    
}
//MARK: - DelegateDataSource
extension MapVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           let reuseIdentifier = "customAnnotation"
           var mk_annView: MKAnnotationView
           
           if annotation is MKUserLocation {
               // Handle user's current location annotation
               mk_annView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
               mk_annView.image = UIImage(named: "pin1") // Show pin1 for current location
           } else {
               // Handle other annotations
               mk_annView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
               mk_annView.image = UIImage(named: "locationUnselect") // Show default pin for other locations
           }
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(annotationTapped))
           mk_annView.addGestureRecognizer(tapGesture)
           
           return mk_annView
       }
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let coord = annotation.coordinate as CLLocationCoordinate2D? else {
//            return nil
//        }
//        let reuseIdentifier = "customAnnotation"
//        let mk_annView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//
//        if coord.latitude == (mapView.selectedAnnotations.first?.coordinate.latitude ?? 0.0){
//            mk_annView.image = UIImage(named: "pin1")
//        } else {
//            mk_annView.image = UIImage(named: "locationUnselect")
//        }
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(annotationTapped))
//        mk_annView.addGestureRecognizer(tapGesture)
//
//        return mk_annView
//    }
    
    @objc func annotationTapped(sender: UITapGestureRecognizer) {
        for i in viewModel?.mapListingData ?? [] {
            if i.name == userName{
                mapUserCollectionView.isHidden = false
            }else {
                mapUserCollectionView.isHidden = true
            }
        }
    }
}
