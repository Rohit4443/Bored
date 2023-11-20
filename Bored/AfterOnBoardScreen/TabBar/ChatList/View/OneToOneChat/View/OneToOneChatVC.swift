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
    
    
    var imagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDelegates()

       
    }
    
    func setTableViewDelegates(){
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "LeftTVCell", bundle: nil), forCellReuseIdentifier: "LeftTVCell")
        chatTableView.register(UINib(nibName: "RightTVCell", bundle: nil), forCellReuseIdentifier: "RightTVCell")
        chatTableView.register(UINib(nibName: "MediaLeftTVCell", bundle: nil), forCellReuseIdentifier: "MediaLeftTVCell")
    }

    @IBAction func sentMessageAction(_ sender: UIButton) {
        
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        popVC()
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
