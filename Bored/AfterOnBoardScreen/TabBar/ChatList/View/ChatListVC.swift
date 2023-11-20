//
//  ChatListVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit

class ChatListVC: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
            
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
            return 2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTVCell", for: indexPath) as! ChatListTVCell
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
       
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            print("Cell \(indexPath.row + 1) clicked")
            let vc = OneToOneChatVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

