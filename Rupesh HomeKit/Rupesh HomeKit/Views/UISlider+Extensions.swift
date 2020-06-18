//
//  UISlider+Extensions.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 08/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

extension UISlider{
    ///returns differnce of maximumValue and minimumValue of the slider
    var difference: Float{
        self.maximumValue - self.minimumValue
    }
}
