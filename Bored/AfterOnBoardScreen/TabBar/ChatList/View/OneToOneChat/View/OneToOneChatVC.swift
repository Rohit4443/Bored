//
//  OneToOneChatVC.swift
//  Bored
//
//  Created by Dr.mac on 30/10/23.
//

import UIKit

class OneToOneChatVC: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var typeMessageTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    var socketton: Socketton?
    var imagePickerController = UIImagePickerController()
    var comeFromChat: Bool?
    var roomID: String?
    var recieverID: Int?
    var chatDetail: ChatListingData?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()
        print("\(roomID)\(recieverID)")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSocket()
        self.profileImage.setImage(image: chatDetail?.userImage,placeholder: UIImage(named: "placeholder"))
        self.userLabel.text = "\(chatDetail?.userFirstName ?? "")\(" ")\(chatDetail?.userLastName ?? "")"
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
        
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        
        if comeFromChat == true{
            popVC()
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
    
}

extension OneToOneChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      //  profileImage.image  = tempImage
        self.dismiss(animated: true, completion: nil)
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
}


extension OneToOneChatVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTVCell", for: indexPath) as! LeftTVCell
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTVCell", for: indexPath) as! RightTVCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaLeftTVCell", for: indexPath) as! MediaLeftTVCell
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension OneToOneChatVC: SockettonDelegate {
    func socketMessageReceived(_ socket: Socketton?, json: JSON) {
        print("new message received \(json)")
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else { return }
//        guard let message = DataDecoder.decodeData(data, type: MessageDetails.self) else { return }
//        insertNewMessage(message: message)
//        self.scrollToBottom(isScrolled: false)
    }
    
    func socketConnected(_ socket: Socketton?) {
        
    }
    
//    MARK: - INSERT NEW MESSAGE
//    func insertNewMessage(message: MessageDetails) {
//        viewModel?.chatHistory.append(message)
//        guard let count = self.viewModel?.chatHistory.count else { return }
//        let indexPath = IndexPath(row: count-1, section: 0)
//        chatTableView.beginUpdates()
//        chatTableView.insertRows(at: [indexPath], with: .bottom)
//        chatTableView.endUpdates()
//       // btnSendMessage.isUserInteractionEnabled = true
//    }
    
//    MARK: - SCROLL TO BOTTOM -
//    func scrollToBottom(isScrolled:Bool) {
//        guard isTableScrolled() == false || isScrolled == true  else { return }
//        guard let count = self.viewModel?.chatHistory.count,
//              count > 0  else { return }
//        let section = 0
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
//            let indexPath = IndexPath(row: count - 1, section: section)
//            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }
    
    func isTableScrolled() -> Bool {
        return (self.chatTableView.contentOffset.y < (self.chatTableView.contentSize.height - SCREEN_SIZE.height))
    }
    
}
