//
//  ReportModel.swift
//  Bored
//
//  Created by Dharmani on 13/12/23.
//

import Foundation

class ReportModel: Codable{
    var status: Int?
    var message: String?
    var data: [ReportData]?
}

class ReportData: Codable{
    var reason_id: String?
    var report_reasons: String?
}
