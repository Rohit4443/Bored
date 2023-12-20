//
//  ReportViewController.swift
//  Bored
//
//  Created by Dharmani on 13/12/23.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var reportTableView: UITableView!
    
    var viewModel:ReportVM?
    var selectedIndex: Int? = nil
    var userId: String?
    var reasonId: String?
    var otherReason: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        // Do any additional setup after loading the view.
    }

    func setTableView(){
        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.registerCell(identifier: "ReportTableViewCell")
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = ReportVM(observer: self)
        self.viewModel?.reportListApi()
    }
    

    @IBAction func backAction(_ sender: UIButton) {
        self.popVC()
        
    }
    

}
extension ReportViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel?.reportList.count ?? 0)
        return viewModel?.reportList.count ?? 0
        //return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        cell.nameLabel.text = "\(viewModel?.reportList[indexPath.row].report_reasons ?? "")"//listArray[indexPath.row]
        cell.passData(data: (viewModel?.reportList[indexPath.row])!)
        
        if indexPath.row == selectedIndex{
            print("selected")
            cell.selectedBtn.setImage(UIImage(named: "ic_select"), for: .normal)
        }else{
            cell.selectedBtn.setImage(UIImage(named: "ic_unSelect"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        print(self.selectedIndex)
        self.reasonId = viewModel?.reportList[indexPath.row].reason_id
        print(viewModel?.reportList[selectedIndex ?? 0].reason_id)
        print("row select reasonID=== \(reasonId)")
        self.reportTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UINib(nibName: "ReportFooterView", bundle: nil).instantiate(withOwner: self,options: nil).first as? ReportFooterView
        footer?.delegate = self
        return footer
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 250
  
    }
}
extension ReportViewController: ReportFooterViewDelegate{
    func otherText(text: String) {
        print(text)
        self.otherReason = text
    }
   
    func submitAction() {
        print(self.otherReason)
        if self.otherReason == nil{
            print(self.reasonId)
            viewModel?.addReportApi(reportTo: self.userId ?? "", reasonId: self.reasonId ?? "", reportReason: "", reportType: "1")
        }else{
            print(otherReason)
            viewModel?.addReportApi(reportTo:self.userId ?? "", reasonId: "0", reportReason: self.otherReason ?? "", reportType: "1")
        }
  
    } 
  
}
extension ReportViewController: ReportVMObserver{
    func addReport() {
        self.popVC()
    }
    
    func reportListing() {
        print("getListing")
        if viewModel?.reportList.count ?? 0 > 0 {
            self.reportTableView.backgroundView = nil
        } else {
            self.reportTableView.setBackgroundView(message: "No Data Found")
        }
        self.reportTableView.reloadData()
    }
    
  
    
}
