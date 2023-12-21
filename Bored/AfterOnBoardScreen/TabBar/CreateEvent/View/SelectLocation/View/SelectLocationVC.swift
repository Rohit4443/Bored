//
//  SelectLocationVC.swift
//  Bored
//
//  Created by Dr.mac on 01/11/23.
//

import UIKit
protocol AddLocationVCDelegate: NSObjectProtocol {
    func setLocation(text: String,lat: Double,long: Double,address:String,country:String)
}

class SelectLocationVC: UIViewController {
    @IBOutlet weak var selectLocationTableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    var delegate: AddLocationVCDelegate?
    var viewModel: SearchLocationVM?
    var timer: Timer?
    var searchValue: String?
    var city : [Cities] = []
    var lat: String?
    var long: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        setViewModel()
    }
    
    func setTableViewDelegates(){
        searchTF.delegate = self
        selectLocationTableView.delegate = self
        selectLocationTableView.dataSource = self
        selectLocationTableView.register(UINib(nibName: "SelectLocationTVCell", bundle: nil), forCellReuseIdentifier: "SelectLocationTVCell")
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func setViewModel(){
        self.viewModel = SearchLocationVM(observer: self)
        self.viewModel?.getSearchListing(search: "", isRecentSearch: "2")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
}


extension SelectLocationVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            print("Count ====== \(viewModel?.searchListing.count)")
            return city.count
        }else{
            return viewModel?.recentSearchListing.count ?? 0
        }
        //            return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationTVCell", for: indexPath) as! SelectLocationTVCell
        if indexPath.section == 0{
            cell.locationLabel.text = city[indexPath.row].city
            cell.deleteButton.isHidden = true
        }else{
            cell.locationLabel.text = viewModel?.recentSearchListing[indexPath.row].search
            cell.deleteButton.isHidden = false
            cell.delegate = self
            cell.passData(data: (viewModel?.recentSearchListing[indexPath.row])!)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        //        headerView.backgroundColor = UIColor.lightGray // Set the background color for the section headers
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0, width: tableView.frame.width - 32, height: 40))
        titleLabel.textColor = UIColor.black // Set the text color for the section headers
        titleLabel.font = UIFont(name: "Poppins-Medium", size: 20)
        if section == 0 {
            titleLabel.text = "Search Location" // Set the title for the first section header
        } else if section == 1 {
            titleLabel.text = "Recent Search Location" // Set the title for the second section header
        }
        
        headerView.addSubview(titleLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0 // Set the height for the section headers
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            SearchGooglePlaces.details(place_id: city[indexPath.row].placeId) { coordinates in
                self.delegate?.setLocation(text: self.city[indexPath.row].city, lat: coordinates?.lat ?? 0.0, long: coordinates?.lng ?? 0.0 , address: self.city[indexPath.row].city, country: self.city[indexPath.row].shortName)
                self.lat = "\(coordinates?.lat ?? Double())"
                self.long = "\(coordinates?.lng ?? Double())"
                print("\(self.lat)\(self.long)")
                self.viewModel?.recentSearchApi(otherUserId:"", isRecentSearch: "2", search: self.city[indexPath.row].city,lat: self.lat ?? "" ,long: self.long ?? "")
            }
           
        }else{
            let lat = Double(viewModel?.recentSearchListing[indexPath.row].latitude ?? "")
            let long = Double(viewModel?.recentSearchListing[indexPath.row].longitude ?? "")
            self.delegate?.setLocation(text: "", lat: lat ?? Double(), long: long ?? Double(), address: viewModel?.recentSearchListing[indexPath.row].search ?? "", country: "")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.popVC()
        }
        
    }
    
    
}
extension SelectLocationVC : UITextFieldDelegate {
    
    private func textFieldDidBeginEditing(_ textField: UITextField) -> Bool {
        print("Start searching ")
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print("updatedText text is :-\(updatedText)")
            self.searchValue = updatedText
            SearchGooglePlaces.findAutocompletePredictions(fromQuery: updatedText) { data in
                DispatchQueue.main.async {
                    self.city = data
                    print("city:- \(self.city.count)")
                    self.selectLocationTableView.reloadData()
                }
            }
        }
        return true
    }
}

extension SelectLocationVC: SearchLocationVMObserver{
    func deleteRecentSearch() {
        self.selectLocationTableView.reloadData()
    }
    
    func recentSearch() {
        self.viewModel?.recentSearchListing.removeAll()
        self.viewModel?.searchListing.removeAll()
        self.viewModel?.getSearchListing(search: self.searchValue ?? "", isRecentSearch: "2")
        self.selectLocationTableView.reloadData()
    }
    
    func searchListing() {
        if viewModel?.searchListing.count == 0 && viewModel?.recentSearchListing.count == 0{
            selectLocationTableView.setBackgroundView(message: "No Searches found")
        }else{
            selectLocationTableView.setBackgroundView(message: "")
            selectLocationTableView.backgroundView = nil
            self.selectLocationTableView.reloadData()
        }
       
    }
    
    
}
extension SelectLocationVC: SelectLocationTVCellDelegate{
    func deleteAction(cell: SelectLocationTVCell) {
        let id = "\(cell.searchLocation?.id ?? "")"
        let search = cell.searchLocation?.search ?? ""
        print(id)
        self.viewModel?.deleteRecentSearch(otherUserId: id, isRecentSearch: "2", search:search)
        self.viewModel?.recentSearchListing.removeAll()
        self.selectLocationTableView.reloadData()
        
        DispatchQueue.main.async {
            self.viewModel?.recentSearchListing.removeAll()
            self.viewModel?.getSearchListing(search: "", isRecentSearch: "2")
            self.selectLocationTableView.reloadData()
        }
    }
  
    
}
