//
//  HMService+Extension.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import HomeKit

//Service extensions to access Data
extension HMService {

    /// The service types present Version support
    enum RHServiceType {
        case bulb, door, fan, unknown
    }

    /// Supported service type for this service.
    var rhServiceType: RHServiceType {
        switch serviceType {
        case HMServiceTypeLightbulb: return .bulb
        case HMServiceTypeGarageDoorOpener: return .door
        case HMServiceTypeFan: return .fan
        default: return .unknown
        }
    }

    /// The primary characteristic type to be controlled, given the service type.
    var primaryControlCharacteristicType: String? {
        switch rhServiceType {
        case .bulb: return HMCharacteristicTypePowerState
        case .door: return HMCharacteristicTypeTargetDoorState
        case .fan: return HMCharacteristicTypePowerState
        case .unknown: return nil
        }
    }

    /// The primary characteristic controlled by tapping the accessory cell in the accessory list.
    var primaryControlCharacteristic: HMCharacteristic? {
        return characteristics.first { $0.characteristicType == primaryControlCharacteristicType }
    }

    /// A tuple containing data of the service
    var serviceDataTuple: (String?, UIImage?,String?,String?) {
        switch rhServiceType {
            //door setUp
        case .door:
            if let value = primaryControlCharacteristic?.value as? Int,
                let doorState = HMCharacteristicValueDoorState(rawValue: value) {
                switch doorState {
                case .open: return (LocalisedStrings.state_open, #imageLiteral(resourceName: "door-open"),self.name,self.accessory?.room?.name)
                case .closed: return (LocalisedStrings.state_closed, #imageLiteral(resourceName: "door-closed"),self.name,self.accessory?.room?.name)
                case .opening: return (
                    LocalisedStrings.state_opening, #imageLiteral(resourceName: "door-opening"),self.name,self.accessory?.room?.name)
                case .closing: return (LocalisedStrings.state_closing, #imageLiteral(resourceName: "door-closing"),self.name,self.accessory?.room?.name)
                case .stopped: return (LocalisedStrings.state_stopped, #imageLiteral(resourceName: "door-closed"),self.name,self.accessory?.room?.name)
                @unknown default: return (LocalisedStrings.state_unknown, nil,self.name,self.accessory?.room?.name)
                }
            } else {
                return (LocalisedStrings.state_unknown, #imageLiteral(resourceName: "door-closed"),self.name,self.accessory?.room?.name)
            }
        case .bulb:
            //bulb setup
            if let value = primaryControlCharacteristic?.value as? Bool {
                if value {
                    return (LocalisedStrings.state_on, #imageLiteral(resourceName: "bulb-on"),self.name,self.accessory?.room?.name)
                } else {
                    return (LocalisedStrings.state_off, #imageLiteral(resourceName: "bulb-off"),self.name,self.accessory?.room?.name)
                }
            } else {
                return (LocalisedStrings.state_unknown, #imageLiteral(resourceName: "bulb-off"),self.name,self.accessory?.room?.name)
            }
        case .fan:
            //fan Setup
            if let value = primaryControlCharacteristic?.value as? Bool {
                if value {
                    return (LocalisedStrings.state_on, #imageLiteral(resourceName: "fanOff"),self.name,self.accessory?.room?.name)
                } else {
                    return (LocalisedStrings.state_off, #imageLiteral(resourceName: "fanOn"),self.name,self.accessory?.room?.name)
                }
            } else {
                return (LocalisedStrings.state_unknown, #imageLiteral(resourceName: "fanOff"),self.name,self.accessory?.room?.name)
            }
        case .unknown:
            return (LocalisedStrings.state_unknown, nil,self.name,self.accessory?.room?.name)
        }
    }

}

