//
//  SearchUserVC.swift
//  Bored
//
//  Created by Dr.mac on 27/10/23.
//

import UIKit

class SearchUserVC: UIViewController {
    
    @IBOutlet weak var searchUserTableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    var viewModel: SearchVM?
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = SearchVM(observer: self)
        self.viewModel?.getSearchListing(search: "")
    }
    
    func setTableViewDelegates(){
        searchTF.delegate = self
        searchUserTableView.delegate = self
        searchUserTableView.dataSource = self
        searchUserTableView.register(UINib(nibName: "SearchUserTVCell", bundle: nil), forCellReuseIdentifier: "SearchUserTVCell")
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    
}


extension SearchUserVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            print("Count ====== \(viewModel?.searchListing.count)")
            return viewModel?.searchListing.count ?? 0
        }else{
            return viewModel?.recentSearchListing.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserTVCell", for: indexPath) as! SearchUserTVCell
        if indexPath.section == 0{
            cell.nameLabel.text = viewModel?.searchListing[indexPath.row].name
            cell.deleteButton.isHidden = true
            cell.profileImage.setImage(image: viewModel?.searchListing[indexPath.row].image,placeholder: UIImage(named: "placeholder"))
            //            cell.passData(data: (viewModel?.searchData[indexPath.row])!)
        }else{
            cell.nameLabel.text = viewModel?.recentSearchListing[indexPath.row].name
            cell.profileImage.setImage(image: viewModel?.recentSearchListing[indexPath.row].image,placeholder: UIImage(named: "placeholder"))
            //            cell.delegate = self
            cell.deleteButton.isHidden = false
            //            cell.passData(data: (viewModel?.recentData[indexPath.row])!)
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
            titleLabel.text = "Search" // Set the title for the first section header
        } else if section == 1 {
            titleLabel.text = "Recent Search" // Set the title for the second section header
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
        if indexPath.section == 1{
            let vc = PlaceDetailVC()
            vc.otherID = viewModel?.recentSearchListing[indexPath.row].id
            vc.comFromSearch = true
            vc.hidesBottomBarWhenPushed = true
            self.pushViewController(vc, true)
        }
    }
    
}

extension SearchUserVC: SearchVMObserver{
    func searchListing() {
        if viewModel?.searchListing.count == 0{
            searchUserTableView.setBackgroundView(message: "No Searches found")
        }else{
            searchUserTableView.setBackgroundView(message: "")
            searchUserTableView.backgroundView = nil
            self.searchUserTableView.reloadData()
        }
    }
    
    
}
extension SearchUserVC : UITextFieldDelegate {
    
    private func textFieldDidBeginEditing(_ textField: UITextField) -> Bool {
        print("Start searching ")
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            if self.timer != nil {
                self.timer?.invalidate()
                self.timer = nil
                
                if self.viewModel?.searchListing.count ?? 0 > 0 {
                    self.viewModel?.searchListing.removeAll()
                    self.searchUserTableView.reloadData()
                }
            }
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.searchText(_:)), userInfo: updatedText, repeats: false)
        }
        return true
    }
    
    
    @objc func searchText(_ timer: Timer) {
        guard let searchKey = timer.userInfo as? String else { return }
        if searchKey.isEmpty{
            self.searchTF.text = ""
            self.viewModel?.searchListing.removeAll()
            self.searchUserTableView.reloadData()
//            self.searchUserTableView.isHidden = true
        } else {
            self.viewModel?.getSearchListing(search: searchKey)
            self.searchUserTableView.reloadData()
//            self.searchTable.isHidden = false
        }
    }
}
