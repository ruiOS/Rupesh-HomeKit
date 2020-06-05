//
//  AppColor.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

///Object that manages colors in the app
class AppColor {
    
    ///default backGroundColor of the app
    static var defaultBackGroundColor: UIColor = UIColor(red: 0.85, green: 0.84, blue: 0.84, alpha: 1)

    ///Accessory List cell cellBackgrouncColor
    static let accessoryCellBackGroundColor: UIColor = UIColor(red: 0.7882, green: 0.3961, blue: 0.9686, alpha: 1)

    ///Navigation bar button's tint color
    static var barButtonItemsBlueColor = UIColor(red:0.14, green:0.52, blue:0.97, alpha:1.00)

    ///Default red color in app
    static var appRedColor = UIColor(red:0.90, green:0.19, blue:0.16, alpha:1.00)

    ///separatorColor
    static var separatorColor: UIColor = UIColor.lightGray

    ///cell Back GroundColor
    static var cellBackGroundColor: UIColor = UIColor.white
}

@available(iOS 13,*)
extension AppColor{
    ///method to set darkMode for devices above iOS13
    static func setColorsForiOS13AndAbove(){
        defaultBackGroundColor = .systemGroupedBackground
        barButtonItemsBlueColor = .systemBlue
        separatorColor = .separator
        appRedColor = .systemRed
        cellBackGroundColor = .systemBackground
    }
}
