//
//  Strings+LocalizableExtensions.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import Foundation

extension String {
    ///Method to get the localised string
    public var localisedString: String {
        return NSLocalizedString(self, comment: "")
    }
}
