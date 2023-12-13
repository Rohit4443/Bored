//
//  BlockedUserVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class BlockedUserVC: UIViewController {

    @IBOutlet weak var blockedUserTableView: UITableView!
    
    var viewModel: BlockedUserVM?
    var viewModel1: PlaceDetailVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blockedUserTableView.delegate = self
        blockedUserTableView.dataSource = self
        blockedUserTableView.register(UINib(nibName: "BlockedUserTVCell", bundle: nil), forCellReuseIdentifier: "BlockedUserTVCell")
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = BlockedUserVM(observer: self)
        self.viewModel1 = PlaceDetailVM(observer: self)
        self.viewModel?.blockListApi(search: "")
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    
}

extension BlockedUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
        return viewModel?.blockList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockedUserTVCell", for: indexPath) as! BlockedUserTVCell
        cell.profileImage.setImage(image: viewModel?.blockList[indexPath.row].image,placeholder: UIImage(named: "placeholder"))
        cell.nameLabel.text = viewModel?.blockList[indexPath.row].name
        cell.passData(data: (viewModel?.blockList[indexPath.row])!)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
    }
    
}
extension BlockedUserVC: BlockedUserTVCellDelegate{
    func unblockAction(cell: BlockedUserTVCell) {
        print("Press button fav")
        let id = "\(cell.blockUserData?.id ?? "")"
        print(id)
        self.viewModel1?.blockUserApi(otherUserID: id, type: "2")
        self.viewModel?.blockList.removeAll()
        self.blockedUserTableView.reloadData()
        
        DispatchQueue.main.async {
            self.viewModel?.blockList.removeAll()
            self.viewModel?.blockListApi(search: "")
            self.blockedUserTableView.reloadData()
        }
    }
    
    
}
extension BlockedUserVC: BlockedUserVMObserver{
    func observerBlockList() {
        print("getListing")
        if viewModel?.blockList.count ?? 0 > 0 {
            self.blockedUserTableView.backgroundView = nil
        } else {
            self.blockedUserTableView.setBackgroundView(message: "No Data Found")
        }
        self.blockedUserTableView.reloadData()
    }
    
    
}
extension BlockedUserVC: PlaceDetailVMObserver{
    func observerDetail() {
       
    }
    
    func blockUser() {
       
    }
    
    
}
