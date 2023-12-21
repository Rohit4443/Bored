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
    
    func hitDeleteChatAlert(index: Int) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this chat?", preferredStyle: .alert)
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        alert.addAction(UIAlertAction(title: "Yes", style: .default , handler:{ (UIAlertAction)in
            let roomId = self.viewModel?.chatListData[index].room_id ?? ""
            print(roomId)
            self.viewModel?.chatDeleteApi(roomID: roomId)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel , handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func convertIntoTime(time: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = dateFormatter.date(from: time) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "hh:mm a"
            let formattedTime = dateFormatter.string(from: date)
            print("Converted Time: \(formattedTime)")
            return formattedTime
        } else {
            print("Invalid date format")
            return nil
        }
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
        
        if let convertedTime = convertIntoTime(time: timestampString) {
            print("Device Time: \(convertedTime)")
            cell.timeLabel.text = convertedTime
        } else {
            print("Conversion failed")
        }

        
//        if let date = dateFormatter.date(from: timestampString) {
//            dateFormatter.dateFormat = "HH:mm a"
//            let formattedTime = dateFormatter.string(from: date)
//            print(formattedTime) // This will print the time in HH:mm a format
//            cell.timeLabel.text = formattedTime
//        } else {
//            print("Invalid date format")
//        }
        
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! ChatListTVCell
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            //YOUR_CODE_HERE
            print("delete called")
            self.hitDeleteChatAlert(index: indexPath.row)
        }
        deleteAction.backgroundColor = .black
        
        // Create a custom view for the delete action
        let deleteView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 70))
        
        let imageView = UIImageView(image: UIImage(named: "del")) // Set your dustbin image here
        imageView.frame = CGRect(x: 8, y: 20, width: 20, height: 20)
        deleteView.addSubview(imageView)
        
        let titleLabel = UILabel(frame: CGRect(x: -5, y: 40, width: 50, height: 20))
        titleLabel.text = "Delete"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        deleteView.addSubview(titleLabel)
        
        deleteAction.image = imageFromView(view: deleteView)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false // This line disables the full swipe behavior
        
        return configuration
    }
    // Helper method to convert a view into an image
    func imageFromView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension ChatListVC: ChatListingVMObserver{
    func chatDelete() {
        self.viewModel?.chatListData.removeAll()
        self.viewModel?.getChatListing(search: "")
        self.chatListTableView.reloadData()
    }
    
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
