//
//  Notification+Extensions.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import Foundation

extension Notification.Name {
    ///Notification to be posted when items are edited
    static let ItemEdited =   Notification.Name("itemEdited")
    ///Notification to be posted when room name is edited
    static let RoomNameEdited = Notification.Name("RoomNameEdited")
    ///Notification to be posted when an item is deleted
    static let ItemDeleted =   Notification.Name("itemDeleted")
}
