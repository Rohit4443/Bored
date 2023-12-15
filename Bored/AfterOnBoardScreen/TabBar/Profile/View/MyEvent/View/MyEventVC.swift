//
//  MyEventVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class MyEventVC: UIViewController {

    @IBOutlet weak var myEventsTableView: UITableView!
    
    var viewModel: HomeVM?
    var viewModel1: MyEventVM?
    var eventID: String?
    var lat: String?
    var long: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        setViewModel()
//        self.viewModel?.eventListing.removeAll()
//        self.viewModel?.eventListingApi(type: "2")
        self.myEventsTableView.reloadData()
    }
    
    func setTableView(){
        myEventsTableView.delegate = self
        myEventsTableView.dataSource = self
        myEventsTableView.register(UINib(nibName: "MyEventTVCell", bundle: nil), forCellReuseIdentifier: "MyEventTVCell")
    }
    
    func setViewModel(){
        self.viewModel = HomeVM(observer: self)
        self.viewModel1 = MyEventVM(observer: self)
        self.lat = UserDefaultsCustom.getProfileData()?.latitude
        self.long = UserDefaultsCustom.getProfileData()?.longitude
        self.viewModel?.eventListingApi(type: "2",lat: self.lat ?? "",long: self.long ?? "")
        self.myEventsTableView.reloadData()
    }
   
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
}

extension MyEventVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
        print(viewModel?.eventListing.count)
        return viewModel?.eventListing.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventTVCell", for: indexPath) as! MyEventTVCell
        cell.titleLabel.text = viewModel?.eventListing[indexPath.row].title
        cell.locationLabel.text = viewModel?.eventListing[indexPath.row].location
        cell.file = viewModel?.eventListing[indexPath.row].files
        cell.eventID = viewModel?.eventListing[indexPath.row].event_id
        cell.delegate = self
        cell.myEventCollectionView.reloadData()
//        cell.menuBtn.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        let date = viewModel?.eventListing[indexPath.row].created_at

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: date ?? "")  {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "d MMM, yyyy"
            
            let outputString = outputDateFormatter.string(from: date)
            print(outputString) // Output: 24 Nov, 2023
            cell.dateLabel.text = outputString
        } else {
            print("Invalid date format")
        }
        
        cell.controller = self
        return cell
        
    }
    
    @objc func menuButtonTapped() {
        let vc = DeleteAccountPopUpVC()
        vc.eventID = eventID
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyEventDetailVC()
        vc.eventID = viewModel?.eventListing[indexPath.row].event_id
        self.pushViewController(vc, true)
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//  
}
extension MyEventVC: HomeVMObserver{
    func observerFilterEventListing() {
        
    }
    
    func observerEventListing() {
        if viewModel?.eventListing.count ?? 0 > 0 {
            self.myEventsTableView.backgroundView = nil
        } else {
            self.myEventsTableView.setBackgroundView(message: "No data found.")
        }
        self.myEventsTableView.reloadData()
    }

    func observerinterestedNotInterested() {
       
    }
 
}
extension MyEventVC: MyEventTVCellDelegate{
    func menuAction(eventID:String) {
        let vc = DeleteAccountPopUpVC()
        print(eventID)
        vc.eventID = eventID
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, true)
    }
    
    
}
extension MyEventVC: DeleteAccountPopUpVCDelegate{
    func deleteEvent(eventID: String) {
        print(eventID)
        viewModel1?.deleteEventApi(eventID: eventID)
    }
    
    
}
extension MyEventVC: MyEventVMObserver{
    func observerDeleteEvent() {
        self.dismiss(animated: true)
        self.viewModel?.eventListing.removeAll()
        DispatchQueue.main.async {
            self.viewModel?.eventListingApi(type: "2",lat:self.lat ?? "",long: self.long ?? "")
            self.myEventsTableView.reloadData()
        }
       
    }
    
    
}
