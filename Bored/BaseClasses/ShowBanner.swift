//
//  ShowBanner.swift
//  SixFigureDays
//
//  Created by apple on 04/08/22.
//

import Foundation
import BRYXBanner

class ShowBanner{
    static func show(title:String?){
        let banner = Banner(title: "Bored", subtitle: title, image: UIImage(named: ""), backgroundColor: .white)
        banner.dismissesOnTap = true
        banner.textColor = .black
        banner.backgroundColor = .white
        banner.show(duration: 1.0)
    }
}
