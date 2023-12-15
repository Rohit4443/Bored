//
//  HomeVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit
import Koloda
import CoreLocation

class HomeVC: UIViewController{
    
    //MARK: - IBOutlets -
    @IBOutlet weak var findInterestCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var eventSwipeKolodaView: KolodaView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var locationManager: CLLocationManager?
    var locationUpdateTimer: Timer?
    var apiCallDelay: TimeInterval = 2.0
    var hasHitAPI = false
    var comeFromFilter = false
    var comeFromFilterToHome = false
    var viewModel: HomeVM?
    var downSwipeCount = 0
    var lat : String?
    var long:String?
    var minValue:String?
    var maxValue:String?
    var interest:String?

    
    
    //MARK: - LifeCycleMethods -
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewDelegates()
        //        setSwipe()
        setSwipeEvent()
        
        //        self.profileImage.setImage(image: UserDefaultsCustom.getUserData()?.image,placeholder: UIImage(named: "placeholder"))
        //        self.nameLabel.text = "\("Hi")\(",")\(UserDefaultsCustom.getUserData()?.first_name ?? "")\(" ")\(UserDefaultsCustom.getUserData()?.last_name ?? "")"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViewModel()
        self.profileImage.setImage(image: UserDefaultsCustom.getUserData()?.image,placeholder: UIImage(named: "placeholder"))
        self.nameLabel.text = "\("Hi")\(", ")\(UserDefaultsCustom.getUserData()?.first_name ?? "")\(" ")\(UserDefaultsCustom.getUserData()?.last_name ?? "")"
        
        
        if comeFromFilterToHome{
        self.viewModel?.pageNo = 0
        self.viewModel?.eventListing = []
        self.viewModel?.eventListingWithFilterApi(type: "1", lat: lat ?? "", long: long ?? "", disStart: minValue ?? "", disEnd: maxValue ?? "", interest: interest ?? "")
        }else{
            setupLocationManager()
        }
    }
    
    func setCollectionViewDelegates(){
        findInterestCollectionView.delegate = self
        findInterestCollectionView.dataSource = self
        findInterestCollectionView.register(UINib(nibName: "HomeFindInterestCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeFindInterestCVCell")
        pageControl.hidesForSinglePage = true
        self.findInterestCollectionView.isPagingEnabled = true
        
        
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest // Set desired accuracy
        locationManager?.requestWhenInUseAuthorization() // Request location authorization
        locationManager?.startUpdatingLocation() // Start receiving location updates
    }
    
    func startLocationUpdateTimer() {
        locationUpdateTimer = Timer.scheduledTimer(timeInterval: apiCallDelay, target: self, selector: #selector(handleLocationUpdate), userInfo: nil, repeats: false)
    }
    
    @objc func handleLocationUpdate() {
        guard let location = locationManager?.location else { return }
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        // Hit the API with the coordinates
        if !hasHitAPI {
            let lat = "\(location.coordinate.latitude)"
            let long = "\(location.coordinate.longitude)"
            UserDefaultsCustom.latitude = lat
            UserDefaultsCustom.longitude = long
//            if comeFromFilter == false{
                self.viewModel?.eventListing = []
                self.viewModel?.pageNo = 0
                self.viewModel?.eventListingApi(type: "1",lat: lat,long: long)
                hasHitAPI = true
//            }else{
//                print("come from filter")
//
//            }
            
        }
    }
 
    func setViewModel(){
        self.hasHitAPI = false
        self.viewModel = HomeVM(observer: self)
//        self.eventSwipeKolodaView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl.currentPage = Int(roundedIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    func setSwipe(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGestureToScroll))
        swipeUp.direction = .up
        swipeUp.cancelsTouchesInView = false
        self.findInterestCollectionView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGestureToScrollDown))
        swipeDown.direction = .down
        swipeDown.cancelsTouchesInView = false
        self.findInterestCollectionView.addGestureRecognizer(swipeDown)
    }
    @objc func handleGestureToScroll(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print("Swipe up")
            
        }
    }
    
    @objc func handleGestureToScrollDown(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print("Swipe down")
        }
    }
    
    
    func setSwipeEvent(){
        eventSwipeKolodaView.delegate = self
        eventSwipeKolodaView.dataSource = self
        eventSwipeKolodaView.reloadData()
    }
    
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
    
    
    //MARK: - IBAction -
    @IBAction func notificationAction(_ sender: UIButton) {
        let vc = NotificationVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc , true)
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        let vc = FilterVC()
        
        vc.completion = {lat,long,minValue,maxValue,interest in
            
            print("lat - ",lat ?? "")
            print("long - ",long ?? "")
            print("minValue - ",minValue ?? "")
            print("maxValue - ",maxValue ?? "")
            print("interest - ",interest ?? "")
            
            self.lat = lat
            self.long = long
            self.minValue = minValue
            self.maxValue = maxValue
            self.interest = interest
            
            self.comeFromFilterToHome = true
            
           
          //
            

        }
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc , true)
        
        //        let vc = ReportUserPopUpVC()
        //        vc.modalPresentationStyle = .overFullScreen
        //        self.navigationController?.present(vc, true)
        
        
    }
}

//MARK: - CollectionView Delegate and DataSource -
extension HomeVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFindInterestCVCell", for: indexPath) as! HomeFindInterestCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width,height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = HomeDetailVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
}

extension HomeVC: KolodaViewDelegate, KolodaViewDataSource{
    
    func kolodaNumberOfCards(_ koloda: Koloda.KolodaView) -> Int {
        //        return 4
        print(viewModel?.eventListing.count)
        return viewModel?.eventListing.count ?? 0
        
    }
    func koloda(_ koloda: Koloda.KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = UINib(nibName: "KolodaCardView", bundle: nil).instantiateView as! KolodaCardView
        
        if let eventListing = viewModel?.eventListing {
            if let files = eventListing[index].files {
                if let fileData = files.first(where: { $0.files != nil }) {
                    if let file = fileData.files {
                        cardView.profileImage.setImage(image: file)
                    }
                }else{
                    cardView.profileImage.setImage(image: "", placeholder: UIImage(named: "eventPlaceholder"))
                }
            }
        }
        
        
        //        for i in 0..<(viewModel?.eventListing.count ?? 0) {
        //            let element = viewModel?.eventListing[i]
        //            print(element)
        //
        //            for j in 0..<(viewModel?.eventListing[i].files?.count ?? 0){
        //                let images = viewModel?.eventListing[i].files?[j]
        //                print(images)
        //                cardView.profileImage.setImage(image: )
        //
        //            }
        //        }
        
        
        print(cardView.profileImage.image ?? UIImage())
        cardView.userProfileImage.setImage(image: viewModel?.eventListing[index].user_image)
        cardView.userNameLabel.text = viewModel?.eventListing[index].user_name
        print(cardView.userNameLabel.text ?? "")
        cardView.locationLAbel.text = viewModel?.eventListing[index].location
        cardView.eventNameLabel.text = viewModel?.eventListing[index].title
        let dateString = viewModel?.eventListing[index].created_at
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateString ?? "")  {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "d MMM, yyyy"
            
            let outputString = outputDateFormatter.string(from: date)
            print(outputString) // Output: 24 Nov, 2023
            cardView.dateLabel.text = outputString
        } else {
            print("Invalid date format")
        }
        
        
        //        if index < iamgeArray.count {
        //                cardView.cardImage.image = UIImage(named: iamgeArray[index])
        //            cardView.cardLabel.text = labelArray[index]
        //            } else {
        //                // Handle the case when the index is out of bounds
        //                // You can set a default image or perform other actions here
        //                cardView.cardImage.image = UIImage(named: "defaultImage")
        //            }
        return cardView
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print(index)
        print("selected")
        let vc = HomeDetailVC()
        vc.eventID = viewModel?.eventListing[index].event_id
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection]{
        [.up,.down]
    }
    
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .up{
            print("Interested")
            let id = viewModel?.eventListing[index].event_id
            print("EVENTSwiped====\(id)")
            viewModel?.interestedNotInterestedApi(type: "1", eventId: id ?? "")
            self.eventSwipeKolodaView.reloadData()
        }else if direction == .down{
            print("Not Interested")
            let id = viewModel?.eventListing[index].event_id
            print("EVENTSwiped====\(id)")
            viewModel?.interestedNotInterestedApi(type: "0", eventId: id ?? "")
            self.eventSwipeKolodaView.reloadData()
            
            downSwipeCount += 1
            if downSwipeCount == 10 {
                let vc = CreateEventPopUp()
                vc.modalPresentationStyle = .overFullScreen
                vc.delegate = self
                self.present(vc, true)
            }
        }
        //        else if direction == .left{
        //            print("Interested left")
        //        }else if direction == .right{
        //            print("Interested right")
        //        }
        
    }
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return true
    }
    
    
}
extension HomeVC: HomeVMObserver{
    func observerFilterEventListing() {
        comeFromFilterToHome = false
        self.eventSwipeKolodaView.reloadData()

    }
    
    func observerinterestedNotInterested() {
        
        self.eventSwipeKolodaView.reloadData()
    }
    
    func observerEventListing() {
        print("getListing")
        //        if viewModel?.eventListing.count ?? 0 > 0 {
        //            self.eventSwipeKolodaView.backgroundView = nil
        //        } else {
        //            self.findInterestCollectionView.setBackgroundView(message: "No Data Found")
        //        }
        self.eventSwipeKolodaView.reloadData()
    }
    
    
}
extension HomeVC: CreateEventPopUpDelegate{
    func createAction(){
        self.dismiss(animated: true, completion: nil)
        
        // Make sure the current view controller is a part of a navigation controller
        guard let navigationController = self.navigationController else {
            return
        }
        
        // Pop to the previous view controller in the navigation stack
        if let previousViewController = navigationController.viewControllers.first(where: { $0 is HomeVC }) {
            navigationController.popToViewController(previousViewController, animated: true)
            tabBarController?.selectedIndex = 2
        }
        
        
        //        let vc = CreateEventVC()
        //        self.dismiss(animated: true)
        //        self.pushViewController(vc, true)
        //
    }
    
    
}
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Stop the location updates to prevent continuous calls to handleLocationUpdate
        locationManager?.stopUpdatingLocation()
        // Start the timer after receiving the initial location
        startLocationUpdateTimer()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
}
