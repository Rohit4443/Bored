//
//  ChatListVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit

class ChatListVC: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    var viewModel: ChatListingVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
//        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = ChatListingVM(observer: self)
        self.viewModel?.getChatListing(search: "")
    }
    
    
    func setTableViewDelegates(){
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.register(UINib(nibName: "ChatListTVCell", bundle: nil), forCellReuseIdentifier: "ChatListTVCell")
        self.navigationController?.navigationBar.isHidden = true
        
    }

    
    @IBAction func searchUserAction(_ sender: UIButton) {
        let vc = SearchUserVC()
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
        
    }
  
}


extension ChatListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.chatListData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTVCell", for: indexPath) as! ChatListTVCell
        cell.nameLabel.text = "\(viewModel?.chatListData[indexPath.row].userFirstName ?? "")\(" ")\(viewModel?.chatListData[indexPath.row].userLastName ?? "")"
        cell.profileImage.setImage(image: viewModel?.chatListData[indexPath.row].userImage,placeholder: UIImage(named: "placeholder"))
        cell.messageLabel.text = viewModel?.chatListData[indexPath.row].LastMessage
        
        if viewModel?.chatListData[indexPath.row].badgeCount == "0"{
            cell.badgeLabel.isHidden = true
        }else{
            cell.badgeLabel.isHidden = false
            cell.badgeLabel.text = viewModel?.chatListData[indexPath.row].badgeCount
        }
        
        let timestampString = viewModel?.chatListData[indexPath.row].LastMessageTime ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: timestampString) {
            dateFormatter.dateFormat = "HH:mm a"
            let formattedTime = dateFormatter.string(from: date)
            print(formattedTime) // This will print the time in HH:mm a format
            cell.timeLabel.text = formattedTime
        } else {
            print("Invalid date format")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Cell \(indexPath.row + 1) clicked")
        let vc = OneToOneChatVC()
        vc.roomID = viewModel?.chatListData[indexPath.row].room_id
        vc.recieverID = viewModel?.chatListData[indexPath.row].id
        vc.chatDetail = viewModel?.chatListData[indexPath.row]
        vc.comeFromChat = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatListVC: ChatListingVMObserver{
    func createRoom() {
        
    }
    
    func observerChatListing() {
        if viewModel?.chatListData.count ?? 0 > 0 {
            self.chatListTableView.backgroundView = nil
        } else {
            self.chatListTableView.setBackgroundView(message: "No Data Found")
        }
        self.chatListTableView.reloadData()
    }
    
    
}
