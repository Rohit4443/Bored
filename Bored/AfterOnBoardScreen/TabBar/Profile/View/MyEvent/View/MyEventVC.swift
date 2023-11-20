//
//  MyEventVC.swift
//  Bored
//
//  Created by Dr.mac on 03/11/23.
//

import UIKit

class MyEventVC: UIViewController {

    @IBOutlet weak var myEventsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    func setTableView(){
        myEventsTableView.delegate = self
        myEventsTableView.dataSource = self
        myEventsTableView.register(UINib(nibName: "MyEventTVCell", bundle: nil), forCellReuseIdentifier: "MyEventTVCell")
    }
   
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
}

extension MyEventVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventTVCell", for: indexPath) as! MyEventTVCell
        cell.controller = self
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//  
}
