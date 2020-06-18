//
//  LocalisedStrings.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 09/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import Foundation

/// Returns a Localised string
 @propertyWrapper struct LocaliseString{
    ///key of the string in localisation.Strings
    let key: String
    ///default value of the string
    let comment: String

    var wrappedValue: String{
        get {
            ///returns localised String
            let localisedString = NSLocalizedString(key, comment: comment)
            //check if localised string exist
            if key == localisedString{
                //return comment if localised string is not present
                return comment
            }else{
                //return localised string if present
                return localisedString
            }
        }
    }

}

///Localised strings to be used in app
struct LocalisedStrings {

    //MARK:- Common

    ///string for "name"
    @LocaliseString(key: "RHKit.common.ios.name", comment: "Name")
    static var common_name: String

    ///string to "Remove Accessory"
    @LocaliseString(key: "RHKit.common.ios.removeAccessory", comment: "Remove Accessory")
    static var common_removeAccessory: String

    //MARK:- Title

    ///string for "Rupesh Accessories"
    @LocaliseString(key: "RHKit.common.ios.title.rupeshAccessories", comment: "Rupesh Accessories")
    static var title_RupeshAccessories: String

    ///string for "Homes List"
    @LocaliseString(key: "RHKit.common.ios.title.homesList", comment: "Homes List")
    static var title_homesList: String

    //MARK:- Detail

    ///string for "Room"
    @LocaliseString(key: "RHKit.common.ios.detail.room", comment: "Room")
    static var detail_room: String

    ///string for "Settings"
    @LocaliseString(key: "RHKit.common.ios.detail.settings", comment: "Settings")
    static var detail_settings: String

    ///string for "Model"
    @LocaliseString(key: "RHKit.common.ios.detail.model", comment: "Model")
    static var detail_model: String

    ///string for "Firmware Version"
    @LocaliseString(key: "RHKit.common.ios.detail.firmwareVersion", comment: "Firmware Version")
    static var detail_firmwareVersion: String

    //MARK:- Alert

    ///string for "error" alert
    @LocaliseString(key: "RHKit.common.ios.alert.error", comment: "error")
    static var alert_error: String

    ///string for "Ok" in alert
    @LocaliseString(key: "RHKit.common.ios.alert.ok", comment: "Ok")
    static var alert_ok: String

    ///string for "Create" in alert
    @LocaliseString(key: "RHKit.common.ios.alert.create", comment: "Create")
    static var alert_create: String

    ///string to "Close"  alert
    @LocaliseString(key: "RHKit.common.ios.alert.close", comment: "Close")
    static var alert_close: String

    ///string for "Remove" in alert
    @LocaliseString(key: "RHKit.common.ios.alert.remove", comment: "Remove")
    static var alert_remove: String

    ///string to "Cancel" alert
    @LocaliseString(key: "RHKit.common.ios.alert.cancel", comment: "Cancel")
    static var alert_cancel: String

    ///string for "Add a Home" alert
    @LocaliseString(key: "RHKit.common.ios.alert.addAHome", comment: "Add a Home")
    static var alert_addHome: String

    ///string for "Add Room" in alert
    @LocaliseString(key: "RHKit.common.ios.alert.addRoom", comment: "Add Room")
    static var alert_addRoom: String

    ///string for "deafult Room Error" in alert
    @LocaliseString(key: "RHKit.common.ios.alert.defaultRoomError", comment: "Default Room can't be deleted")
    static var alert_defaultRoomError: String

    ///string to "confirm removal of accessory" in alert
    @LocaliseString(key: "RHKit.common.ios.alert.areYouSureToRemoveAccessory", comment: "Are you sure you want to remove this accessory?")
    static var alert_areYouSureToRemoveAccessory: String

    //MARK:- State

    ///string for "unknown" state
    @LocaliseString(key: "RHKit.common.ios.service.state.unknown", comment: "Unknown")
    static var state_unknown: String

    ///string for "on" state
    @LocaliseString(key: "RHKit.common.ios.service.state.on", comment: "On")
    static var state_on: String

    ///string for "off" state
    @LocaliseString(key: "RHKit.common.ios.service.state.off", comment: "Off")
    static var state_off: String

    ///string for "closed" state
    @LocaliseString(key: "RHKit.common.ios.service.state.closed", comment: "Closed")
    static var state_closed: String

    ///string for "closing" state
    @LocaliseString(key: "RHKit.common.ios.service.state.closing", comment: "Closing")
    static var state_closing: String

    ///string for "opening" state
    @LocaliseString(key: "RHKit.common.ios.service.state.opening", comment: "Opening")
    static var state_opening: String

    ///string for "stopped" state
    @LocaliseString(key: "RHKit.common.ios.service.state.stopped", comment: "Stopped")
    static var state_stopped: String

    ///string for "open" state
    @LocaliseString(key: "RHKit.common.ios.service.state.open", comment: "Open")
    static var state_open: String

    ///string for "secured" state
    @LocaliseString(key: "RHKit.common.ios.service.state.secured", comment: "Secured")
    static var state_secured: String

    ///string for "unsecured" state
    @LocaliseString(key: "RHKit.common.ios.service.state.unsecured", comment: "Unsecured")
    static var state_unsecured: String

    ///string for "jammed" state
    @LocaliseString(key: "RHKit.common.ios.service.state.jammed", comment: "Jammed")
    static var state_jammed: String

    ///string for "loacked" state
    @LocaliseString(key: "RHKit.common.ios.service.state.locked", comment: "Locked")
    static var state_locked: String

    ///string for "not locked" state
    @LocaliseString(key: "RHKit.common.ios.service.state.notLocked", comment: "Not Locked")
    static var state_notLocked: String

    ///string for "clockwise" rotation
    @LocaliseString(key: "RHKit.common.ios.service.state.clockwise", comment: "Clockwise")
    static var state_clockwise: String

    ///string for "counter-clockwise" rotation
    @LocaliseString(key: "RHKit.common.ios.service.state.counterClockWise", comment: "Counter-clockwise")
    static var state_counterClockwise: String

    //MARK:- Error

    ///Error to display when changing state failed
    @LocaliseString(key: "RHKit.common.ios.error.changeStateFailed", comment: "Failed to Change State")
    static var error_changeStateFailed: String

}
