//
//  EditDeleteEventPopUpVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class EditDeleteEventPopUpVC: UIViewController {
    
    @IBOutlet var containerView: UIView!
    
    var controller: UIViewController?
    var eventID: String?
    var eventData: HomeDetailData?
    var viewModel: MyEventVM?
    var imageArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapgesture))
        containerView.addGestureRecognizer(tapGesture)
        print(eventID)
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = MyEventVM(observer: self)
    }
    
    @objc func tapgesture(){
        dismiss(animated: true)}
    
    
    @IBAction func editEventAction(_ sender: UIButton) {
        dismiss(animated: true)
        let vc = CreateEventVC()
        vc.eventDetail = eventData
        if let events = eventData?.files {
            var imageArray = [UIImage]()
            
            for event in events {
                if let urlString = event.files, // Accessing the 'files' property assuming it holds the URL string
                   let imageURL = URL(string: urlString),
                   let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    imageArray.append(image)
                    print(imageArray.count)
                }
            }
            
            vc.imageArray = imageArray
            vc.comeFrom = "EditEvent"
            vc.interestID = eventData?.event_tags
            controller?.pushViewController(vc, true)
        } else {
            // Handle the case where eventData or its files are nil
        }
        // vc.imageArray = getImageArrayFromFiles(files: eventData?.files)
//        vc.comeFrom = "EditEvent"
//        controller?.pushViewController(vc, true)
    }
    
    
    @IBAction func deleteEventAction(_ sender: UIButton) {
        dismiss(animated: true)
        let vc = DeleteAccountPopUpVC()
        print(eventID)
        vc.eventID = eventID
        vc.delegate = self
        controller?.modalPresentationStyle = .overFullScreen
        controller?.present(vc, true)
    }
    
}
extension EditDeleteEventPopUpVC: DeleteAccountPopUpVCDelegate{
    func deleteEvent(eventID: String) {
        print(eventID)
        viewModel?.deleteEventApi(eventID: eventID)
    }
    
    
}
extension EditDeleteEventPopUpVC: MyEventVMObserver{
    func observerDeleteEvent() {
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("DeleteEventNotification"), object: nil)
    }
    
    
}
