//
//  TabBarVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit
import Kingfisher

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabController()
        tabBar.backgroundColor = .white
        self.tabBar.items?.last?.setImageFromUrl()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 100
        tabBar.frame.origin.y = view.frame.size.height - 72
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.items?.last?.setImageFromUrl()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.tabBar.items?.last?.setImageFromUrl()
    }
    
    func setTabController() {
       
        
        
        let controller1 = HomeVC()
        let controller2 = MapVC()
        let controller3 = CreateEventVC()
        let controller4 = ChatListVC()
        let controller5 = ProfileVC()
        
       
        
        controller1.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_Home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_selectedHome")?.withRenderingMode(.alwaysOriginal))
        
        controller2.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_map")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_selectedMap")?.withRenderingMode(.alwaysOriginal))
        
        controller3.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_createEvent")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_selectedCreateEvent")?.withRenderingMode(.alwaysOriginal))
       
        
        controller4.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_chat")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_selectedChat")?.withRenderingMode(.alwaysOriginal))
        
        controller5.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "ic_profile")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_selectedProfile")?.withRenderingMode(.alwaysOriginal))
        
        
        let v1 =  UINavigationController(rootViewController: controller1)
        v1.navigationBar.isHidden = true
        
        let v2 =  UINavigationController(rootViewController: controller2)
        v2.navigationBar.isHidden = true
        
        let v3 =  UINavigationController(rootViewController: controller3)
        v3.navigationBar.isHidden = true
        
        let v4 =  UINavigationController(rootViewController: controller4)
        v3.navigationBar.isHidden = true
        
        let v5 =  UINavigationController(rootViewController: controller5)
        v3.navigationBar.isHidden = true
        
        self.viewControllers = [v1, v2, v3, v4, v5]
    }
}


extension UITabBarItem {
func setImageFromUrl() {
    let imgUrl = UserDefaultsCustom.getProfileData()?.image// UIImage(named: "profilesel")
 let defImg = "tabPlaceholder"
    let fghj = UIImage(named: defImg)?.withRenderingMode(.alwaysOriginal)
 self.image = fghj?.withRenderingMode(.alwaysOriginal)
 self.selectedImage = fghj?.withRenderingMode(.alwaysOriginal).roundedImageWithBorder(width: 2,color: .white)
//    self.selectedImage = imgUrl?.roundedImageWithBorder(width: 1,color: .black)
    if let imageUrl = imgUrl,let url = URL(string: imageUrl) { //let url = URL(string: "profilesel") {
     let targetSize = CGSize(width: 24.0, height: 24.0)
     let resize = ResizingImageProcessor(referenceSize: targetSize, mode: .aspectFill)
     let crop = CroppingImageProcessor(size: targetSize)
     let round = RoundCornerImageProcessor(cornerRadius: targetSize.height / 2,backgroundColor: .black)
   
     let processor = ((resize |> crop) |> round)
     KingfisherManager.shared.retrieveImage(with: url,options: [ .processor(processor), .scaleFactor(UIScreen.main.scale)],completionHandler: { result in
         switch result {
         case .success(let value):
             let img = value.image
             self.image = img.roundedImageWithBorder(width: 0,color: .clear)//.withRenderingMode(.automatic).roundedImageWithBorder(width: 0)
             self.selectedImage = img.roundedImageWithBorder(width: 1,color: .black)//withRenderingMode(.automatic).roundedImageWithBorder(width: 1)
             
//                    self.selectedImage?.sd_roundedCornerImage(withRadius: (self.selectedImage?.size.height ?? 0) / 2, corners: SDRectCorner.allCorners, borderWidth: 5, borderColor: .red)
         case .failure(let error):
             print("Failed to load image, error: \(error)")
         }
     })
 }
}
}
extension UIImage {
    

    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()

        let innerRect = CGRect(x: (size.width/2) - (lineHeight/2) - 0,y: size.height - lineHeight - 2,width: lineHeight,height: lineHeight)

        let path = UIBezierPath(roundedRect: innerRect, cornerRadius: lineHeight/2)
        path.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()
//        image?.sd_roundedCornerImage(withRadius: image?.size.height ?? 0 / 2, corners: SDRectCorner.allCorners, borderWidth: 5, borderColor: .black)

        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    func roundedImageWithBorder(width: CGFloat, color: UIColor = .white ) -> UIImage? {
          let square = CGSize(width: min(size.width, size.height) + width / 2, height: min(size.width, size.height) + width / 2)
          let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
          imageView.contentMode = .center
          imageView.image = self
          imageView.layer.cornerRadius = square.width/2
          imageView.layer.masksToBounds = true
          imageView.layer.borderWidth = width
          imageView.layer.borderColor = color.cgColor
          UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
          guard let context = UIGraphicsGetCurrentContext() else { return nil }
          imageView.layer.render(in: context)
          var result = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          result = result?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
          return result
      }
    

}
