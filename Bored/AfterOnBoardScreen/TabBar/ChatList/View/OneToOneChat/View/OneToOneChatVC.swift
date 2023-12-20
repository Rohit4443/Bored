//
//  OneToOneChatVC.swift
//  Bored
//
//  Created by Dr.mac on 30/10/23.
//

import UIKit
import IQKeyboardManagerSwift
import GrowingTextView

class OneToOneChatVC: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var typeMessageTextView: GrowingTextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var sendMessageBtn: UIButton!
    
    var socketton: Socketton?
    var viewModel: OneToOneChatVM?
    var imagePickerController = UIImagePickerController()
    var comeFromChat: Bool?
    var roomID: String?
    var recieverID: Int?
    var chatDetail: ChatListingData?
    var timeFormat = "hh:mm a"
    var mediaImage: Data?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        print("\(roomID)\(recieverID)")
        setViewModel()
      
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSocket()
      
        self.viewModel?.allMessageListApi(roomID: roomID ?? "")
    }
    
    func setViewModel(){
        self.viewModel = OneToOneChatVM(observer: self)
    }
    
    func setSocket() {
        guard socketton == nil else { return }
        socketton = Socketton()
        socketton?.delegate = self
        socketton?.establishConnection()
        socketton?.checkConnection(complition: { succ in
            if succ == true {
                self.socketton?.conncetedChat(roomId: self.roomID ?? "")
                
            }
        })
    }
    
    func setTableViewDelegates(){
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "LeftTVCell", bundle: nil), forCellReuseIdentifier: "LeftTVCell")
        chatTableView.register(UINib(nibName: "RightTVCell", bundle: nil), forCellReuseIdentifier: "RightTVCell")
        chatTableView.register(UINib(nibName: "MediaLeftTVCell", bundle: nil), forCellReuseIdentifier: "MediaLeftTVCell")
        chatTableView.register(UINib(nibName: "MediaRightTVCell", bundle: nil), forCellReuseIdentifier: "MediaRightTVCell")
    }
    
    func poptoSpecificVC(viewController : Swift.AnyClass){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController.isKind(of: viewController) {
                self.navigationController!.popToViewController(aViewController, animated: false)
                break;
            }
        }
    }

    @IBAction func sentMessageAction(_ sender: UIButton) {
        
        let message = (typeMessageTextView.text ?? "").trim
        print(message)
            guard message.count > 0 else { return }
        let recieverID = "\(recieverID ?? Int())"
        viewModel?.sendMessageApi(recieverID: recieverID, roomID: roomID ?? "", message: message, messageType: "0", file: Data())
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        
        if comeFromChat == true{
//            popVC()
            viewModel?.apiUpdateSeenStatus(roomID: roomID ?? "")
        }else{
            guard let navigationController = self.navigationController else {
                return
            }
            
            // Pop to the previous view controller in the navigation stack
            if let previousViewController = navigationController.viewControllers.first(where: { $0 is PlaceDetailVC }) {
                navigationController.popToViewController(previousViewController, animated: true)
                tabBarController?.selectedIndex = 3
                
                //        self.poptoSpecificVC(viewController: ChatListVC.self)
               
            }
        }

    }
    
    @IBAction func openGalleryAction(_ sender: UIButton) {
        openCamera()
    }
    
    @IBAction func otherProfileAction(_ sender: UIButton) {
        let vc = PlaceDetailVC()
        vc.otherID = "\(recieverID ?? 0)"
        vc.comFromSearch = true
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc, true)
    }
}

extension OneToOneChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.image = tempImage
        print(self.image)
        let mediaImage = tempImage.jpegData(compressionQuality: 0.8)
        print(mediaImage)
        self.mediaImage = mediaImage
        print(self.mediaImage)
        self.dismiss(animated: true, completion: nil)
        let id = "\(recieverID ?? 0)"
        viewModel?.sendMessageApi(recieverID: id, roomID: roomID ?? "", message: "", messageType: "1", file: self.mediaImage ?? Data())
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func openCamera(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Camera", style: .default){ [self] action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera;
                imagePickerController.allowsEditing = true
                self.imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Camera not found", message: "This device has no camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
                present(alert, animated: true,completion: nil)
            }
        }
        let action1 = UIAlertAction(title: "Gallery", style: .default){ action in
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.delegate = self
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // You can change the format as needed
        
        let currentTime = formatter.string(from: Date())
        return currentTime
    }

}


extension OneToOneChatVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
        print(viewModel?.chatHistory.count ?? 0)
        return viewModel?.chatHistory.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = self.viewModel?.chatHistory[indexPath.row]
        let iddd = self.viewModel?.userDetail?.id
        let someID = dict?.sender_id
        print(someID)
        print(iddd)
       
        print(UserDefaultsCustom.getUserData()?.id)
        switch dict?.message_type {
        case 0:
            
            if someID != Int(UserDefaultsCustom.getUserData()?.id ?? "") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTVCell", for: indexPath) as! LeftTVCell
                cell.leftMessageLabel.text = dict?.message
                cell.userProfileImage.setImage(image: self.viewModel?.userDetail?.image,placeholder: UIImage(named: "placeholder"))
                cell.userNameLabel.text = self.viewModel?.userDetail?.name
                cell.messsageBGView.clipsToBounds = true
                
//                let date = Date(timeIntervalSince1970: TimeInterval(dict?.created_at ?? "") ?? 0.0)
                let dateString = dict?.created_at ?? ""
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                print(dict?.created_at ?? "")
                let date = dateFormatter.date(from: dateString)
                print(date)
                
//                cell.lblTime.text = date?.dateToString(format: timeFormat)
                cell.lblTime.text = dateString.convertTimeStampToStringDate(format: "hh:mm a")
                if indexPath.row == 0 {
                cell.setDate(currentDate: date, previousDate: nil)
                }else{
                    let preDate = self.viewModel?.chatHistory[indexPath.row - 1].created_at ?? ""
                    let previousDate = dateFormatter.date(from: preDate)
                    cell.setDate(currentDate:date, previousDate:  previousDate)
                }
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightTVCell", for: indexPath) as! RightTVCell
                cell.rightMessageLabel.text = dict?.message
                cell.messageBGView.clipsToBounds = true
                print(dict?.created_at ?? "")
//                let date = Date(timeIntervalSince1970: TimeInterval(dict?.created_at ?? "") ?? 0.0)
                let dateString = dict?.created_at ?? ""
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                let date = dateFormatter.date(from: dateString)
                    print(date)
                
                
                cell.rightProfileImage.setImage(image: UserDefaultsCustom.getUserData()?.image,placeholder: UIImage(named: "placeholder"))
                cell.rightUserNameLabel.text = UserDefaultsCustom.getUserData()?.name
//                cell.lblTime.text = date?.dateToString(format: timeFormat)
                cell.lblTime.text = dateString.convertTimeStampToStringDate(format: "hh:mm a")
                print(cell.lblTime)
                if indexPath.row == 0 {
                cell.setDate(currentDate: date, previousDate: nil)
                }else{
                    let previousDate = self.viewModel?.chatHistory[indexPath.row - 1].created_at ?? ""
                    let preDate = dateFormatter.date(from: previousDate)
                    print(preDate)
                    cell.setDate(currentDate: date, previousDate:  preDate)
                }
                
                return cell
            }
        case 1:
            if someID != Int(UserDefaultsCustom.getUserData()?.id ?? "") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MediaLeftTVCell", for: indexPath) as! MediaLeftTVCell
                cell.userProfileImage.setImage(image: self.viewModel?.userDetail?.image,placeholder: UIImage(named: "placeholder"))
                cell.userNameLabel.text = self.viewModel?.userDetail?.name
                let dateString = dict?.created_at ?? ""

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                let date = dateFormatter.date(from: dateString)
                print(date)
                cell.timeLabel.text = date?.dateToString(format: timeFormat)
                cell.imageMessage.setImage(image: dict?.files)
                if indexPath.row == 0 {
                cell.setDate(currentDate: date, previousDate: nil)
                }else{
                    let previousDate = self.viewModel?.chatHistory[indexPath.row - 1].created_at ?? ""
                    let preDate = dateFormatter.date(from: previousDate)
                    print(preDate)
                    cell.setDate(currentDate: date, previousDate:  preDate)
                }
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MediaRightTVCell", for: indexPath) as! MediaRightTVCell
                cell.profileImage.setImage(image: UserDefaultsCustom.getUserData()?.image,placeholder: UIImage(named: "placeholder"))
                cell.userNAmeLabel.text = UserDefaultsCustom.getUserData()?.name
                let dateString = dict?.created_at ?? ""

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                let date = dateFormatter.date(from: dateString)
                print(date)
                cell.timeLabel.text = date?.dateToString(format: timeFormat)
                cell.imageMessage.setImage(image: dict?.files)
                if indexPath.row == 0 {
                cell.setDate(currentDate: date, previousDate: nil)
                }else{
                    let previousDate = self.viewModel?.chatHistory[indexPath.row - 1].created_at ?? ""
                    let preDate = dateFormatter.date(from: previousDate)
                    print(preDate)
                    cell.setDate(currentDate: date, previousDate:  preDate)
                }
                return cell
            }
            
        default:
            return UITableViewCell()
            
        }
        
        
//        if indexPath.row == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTVCell", for: indexPath) as! LeftTVCell
//            return cell
//        }else if indexPath.row == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTVCell", for: indexPath) as! RightTVCell
//            return cell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaLeftTVCell", for: indexPath) as! MediaLeftTVCell
//            return cell
//
//        }
        
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            self.checkHeaderAnimation(row: indexPath.row)
            print("pageNo---",self.viewModel?.pageNo ?? 0)
//            self.viewModel?.allMessageListApi(roomID: roomID ?? "")
        }
    }
    
}

extension OneToOneChatVC: SockettonDelegate {
    func socketMessageReceived(_ socket: Socketton?, json: JSON) {
        print("new message received \(json)")
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else { return }
        guard let message = DataDecoder.decodeData(data, type: SendMessageData.self) else { return }
        insertNewMessage(message: message)
        self.scrollToBottom(isScrolled: false)
    }
    
    func socketConnected(_ socket: Socketton?) {
        
    }
    
//    MARK: - INSERT NEW MESSAGE
    func insertNewMessage(message: SendMessageData) {
        viewModel?.chatHistory.append(message)
        guard let count = self.viewModel?.chatHistory.count else { return }
        let indexPath = IndexPath(row: count-1, section: 0)
        chatTableView.beginUpdates()
        chatTableView.insertRows(at: [indexPath], with: .bottom)
        chatTableView.endUpdates()
       // btnSendMessage.isUserInteractionEnabled = true
    }
    
//    MARK: - SCROLL TO BOTTOM -
    func scrollToBottom(isScrolled:Bool) {
        guard isTableScrolled() == false || isScrolled == true  else { return }
        guard let count = self.viewModel?.chatHistory.count,
              count > 0  else { return }
        let section = 0
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
            let indexPath = IndexPath(row: count - 1, section: section)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func isTableScrolled() -> Bool {
        return (self.chatTableView.contentOffset.y < (self.chatTableView.contentSize.height - SCREEN_SIZE.height))
    }
    
}
extension OneToOneChatVC: OneToOneChatVMObserver{
    func updateMessage() {
        self.popVC()
    }
    
    func sendMessageApi(message: SendMessageData, json: [String : Any]) {
        print(message)
        insertNewMessage(message: message)
        scrollToBottom(isScrolled: true)
        sendMessageBtn.isEnabled = true
        typeMessageTextView.text = nil
        print("send message is \(json) ***** \(self.socketton == nil)")
        socketton?.sendMessage(json, roomId: roomID ?? "")
        self.chatTableView.tableHeaderView = nil
        sendMessageBtn.isUserInteractionEnabled = true
   
    }
    
    
    func getAllMessage() {
        print(viewModel?.userDetail)
        self.profileImage.setImage(image: viewModel?.userDetail?.image,placeholder: UIImage(named: "placeholder"))
        self.userLabel.text = "\(viewModel?.userDetail?.first_name ?? "")\(" ")\(viewModel?.userDetail?.last_name ?? "")"
        chatTableView.reloadData()
        chatTableView.tableHeaderView = nil
        scrollToBottom(isScrolled: true)
    }
      
    
}
