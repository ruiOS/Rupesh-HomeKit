//
//  Float+Extensions.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 08/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

extension Float {
    /// provides rounded value for a slider
    /// - Parameter slider: slider to which rounded value need to be provided
    /// - Returns: a rounded float vlaue
    func roundedValue(forSlider slider: UISlider) -> Float {
        if slider.maximumValue - slider.minimumValue > 1{
            //rounded with no decimal points if slider slides more than 10 integers
            return self.rounded()
        }else{
            //rounded with one decimal point if slider slides less than 10 integers
            let divisor = pow(10.0, Float(1))
            return (self * divisor).rounded() / divisor
        }
    }
}
