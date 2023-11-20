//
//  TabBarVC.swift
//  Bored
//
//  Created by Dr.mac on 25/10/23.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabController()
        tabBar.backgroundColor = .white
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 100
        tabBar.frame.origin.y = view.frame.size.height - 72
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


