//
//  UIView+Extensions.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

extension UIView{

    //set safelayout anchors to use across the app
    var safeTopAnchor: NSLayoutYAxisAnchor{
        get{
            if #available(iOS 11.0, *){
                return safeAreaLayoutGuide.topAnchor
            }
            return topAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor{
        get{
            if #available(iOS 11.0, *){
                return safeAreaLayoutGuide.bottomAnchor
            }
            return bottomAnchor
        }
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor{
        get{
            if #available(iOS 11.0, *){
                return safeAreaLayoutGuide.leadingAnchor
            }
            return leadingAnchor
        }
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor{
        get{
            if #available(iOS 11.0, *){
                return safeAreaLayoutGuide.trailingAnchor
            }
            return trailingAnchor
        }
    }

}
