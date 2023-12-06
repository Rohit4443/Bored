//
//  NotificationVC.swift
//  Bored
//
//  Created by Dr.mac on 26/10/23.
//

import UIKit

class NotificationVC: UIViewController {
    @IBOutlet weak var notificationShowTableView: UITableView!
    
    var viewModel: NotificationVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = NotificationVM(observer: self)
        self.viewModel?.getNotification()
    }
    
    
    func setTableViewDelegates(){
        notificationShowTableView.delegate = self
        notificationShowTableView.dataSource = self
        notificationShowTableView.register(UINib(nibName: "NotificationTVCell", bundle: nil), forCellReuseIdentifier: "NotificationTVCell")

    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: date as Date)
    }
   

    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}


extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
        return viewModel?.notificationListing.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVCell", for: indexPath) as! NotificationTVCell
        cell.userNotificationImage.setImage(image: viewModel?.notificationListing[indexPath.row].image)
        cell.notificationLabel.text = "\(viewModel?.notificationListing[indexPath.row].name ?? "")\(" ")\("show interest in the event")"
        let time = Double(self.viewModel?.notificationListing[indexPath.row].created_at ?? "")
        cell.timeLabel.text =  self.timeStringFromUnixTime(unixTime: time ?? 0.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension NotificationVC: NotificationVMObserver{
    func getListing() {
        if viewModel?.notificationListing.count ?? 0 > 0 {
            self.notificationShowTableView.backgroundView = nil
        } else {
            self.notificationShowTableView.setBackgroundView(message: "No Data Found")
        }
        self.notificationShowTableView.reloadData()
    }
    
    
}
