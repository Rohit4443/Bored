//
//  ReportVM.swift
//  Bored
//
//  Created by Dharmani on 13/12/23.
//

import Foundation
import SVProgressHUD
protocol ReportVMObserver{
    func reportListing()
    func addReport()
}

class ReportVM: NSObject{
    
    var observer: ReportVMObserver?
    var reportList: [ReportData] = []
    
    init(observer: ReportVMObserver? = nil) {
        self.observer = observer
    }
    
    func reportListApi(){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.reportList, params: nil, success: {
            (response) in
                print(response)
                SVProgressHUD.dismiss()
                if let parsedData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) {
                    do {
                        let userModel = try JSONDecoder().decode(ReportModel.self, from: parsedData)
                        if let data = userModel.data {
                            self.reportList.append(contentsOf: data)
                            print(self.reportList.count)
                        } else {
                            self.reportList.removeAll()
                        }
                        self.observer?.reportListing()
                        
                    } catch {
                        print(error)
                    }
                   
                }
        }, failure: {
            (error) in
                print(error.debugDescription)
        })
    }
    
    func addReportParams(reportTo: String, reasonId: String, reportReason: String, reportType: String) -> [String:Any]{
        let params: [String:Any] = [
            "reported_to": reportTo,
            "reason_id": reasonId,
            "reported_reason": reportReason,
            "reported_type": reportType
        ]
        print("parameters:-  \(params)")
        return params
    }
    
    func addReportApi(reportTo: String, reasonId: String, reportReason: String, reportType: String){
        SVProgressHUD.show()
        AFWrapperClass.sharedInstance.requestPOSTSURL(Constant.addReport, params:addReportParams(reportTo: reportTo, reasonId: reasonId, reportReason: reportReason, reportType: reportType), success: {
            (response) in
            print("response = \(response)")
            SVProgressHUD.dismiss()
            if let status = response["status"] as? Int,
               status == 200 {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .success)
                self.observer?.addReport()
            } else {
                let msg = response["message"] as? String
                Singleton.showMessage(message: msg ?? "", isError: .error)
            }
        }, failure: {
            (error) in
            print(error.debugDescription)
        })
        
        
    }
}
