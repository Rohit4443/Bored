//
//  ViewAllInterestedEvents.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class ViewAllInterestedEvents: UIViewController {
    @IBOutlet weak var ViewAllinterestedEventsTableView: UITableView!
    
    var viewModel: InterestedScreenVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        setViewModel()
        
    }
    
    func setViewModel(){
        self.viewModel = InterestedScreenVM(observer: self)
        self.viewModel?.interestListingApi()
    }
    
    
    func setTableView(){
        self.ViewAllinterestedEventsTableView.delegate = self
        self.ViewAllinterestedEventsTableView.dataSource = self
        self.ViewAllinterestedEventsTableView.register(UINib(nibName: "ProfileEventsTVCell", bundle: nil), forCellReuseIdentifier: "ProfileEventsTVCell")
        
    }
   
    @IBAction func settingAction(_ sender: UIButton) {
        let vc = SettingsVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}
extension ViewAllInterestedEvents: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
        return viewModel?.interestedData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEventsTVCell", for: indexPath) as! ProfileEventsTVCell
        cell.userNameLabel.text = viewModel?.interestedData[indexPath.row].user_name
        cell.userProfileImage.setImage(image: viewModel?.interestedData[indexPath.row].user_image,placeholder: UIImage(named: "placeholder"))
        cell.titleLabel.text = viewModel?.interestedData[indexPath.row].title
        cell.locationLabel.text = viewModel?.interestedData[indexPath.row].location
        cell.file = viewModel?.interestedData[indexPath.row].files
        
        
        let date = viewModel?.interestedData[indexPath.row].created_at
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: date ?? "")  {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "d MMM, yyyy"
            
            let outputString = outputDateFormatter.string(from: date)
            print(outputString) // Output: 24 Nov, 2023
            cell.dateLAbel.text = outputString
        } else {
            print("Invalid date format")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension ViewAllInterestedEvents: InterestedScreenVMObserver{
    func observerInterestListing() {
        if viewModel?.interestedData.count ?? 0 > 0 {
            self.ViewAllinterestedEventsTableView.backgroundView = nil
        } else {
            self.ViewAllinterestedEventsTableView.setBackgroundView(message: "No data found.")
        }
        self.ViewAllinterestedEventsTableView.reloadData()
    }

    
}
