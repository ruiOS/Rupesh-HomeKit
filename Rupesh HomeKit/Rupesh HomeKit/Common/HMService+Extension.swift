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

    /// The service types that Kilgo garage doors support.
    enum RHServiceType {
        case bulb, door, unknown
    }

    /// The Kilgo service type for this service.
    var rhServiceType: RHServiceType {
        switch serviceType {
        case HMServiceTypeLightbulb: return .bulb
        case HMServiceTypeGarageDoorOpener: return .door
        default: return .unknown
        }
    }

    /// The primary characteristic type to be controlled, given the service type.
    var primaryControlCharacteristicType: String? {
        switch rhServiceType {
        case .bulb: return HMCharacteristicTypePowerState
        case .door: return HMCharacteristicTypeTargetDoorState
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
        case .door:
            if let value = primaryControlCharacteristic?.value as? Int,
                let doorState = HMCharacteristicValueDoorState(rawValue: value) {
                switch doorState {
                case .open: return ("RHKit.common.ios.service.state.open".localisedString, #imageLiteral(resourceName: "door-open"),self.name,self.self.accessory?.room?.name)
                case .closed: return ("RHKit.common.ios.service.state.closed".localisedString, #imageLiteral(resourceName: "door-closed"),self.name,self.self.accessory?.room?.name)
                case .opening: return (
                    "RHKit.common.ios.service.state.opening".localisedString, #imageLiteral(resourceName: "door-opening"),self.name,self.self.accessory?.room?.name)
                case .closing: return ("RHKit.common.ios.service.state.closing".localisedString, #imageLiteral(resourceName: "door-closing"),self.name,self.self.accessory?.room?.name)
                case .stopped: return ("RHKit.common.ios.service.state.stopped".localisedString, #imageLiteral(resourceName: "door-closed"),self.name,self.self.accessory?.room?.name)
                @unknown default: return ("RHKit.common.ios.unknown".localisedString, nil,self.name,self.self.accessory?.room?.name)
                }
            } else {
                return ("RHKit.common.ios.service.state.unknown".localisedString, #imageLiteral(resourceName: "door-closed"),self.name,self.self.accessory?.room?.name)
            }
        case .bulb:
            if let value = primaryControlCharacteristic?.value as? Bool {
                if value {
                    return ("RHKit.common.ios.service.state.on".localisedString, #imageLiteral(resourceName: "bulb-on"),self.name,self.self.accessory?.room?.name)
                } else {
                    return ("RHKit.common.ios.service.state.off".localisedString, #imageLiteral(resourceName: "bulb-off"),self.name,self.self.accessory?.room?.name)
                }
            } else {
                return ("RHKit.common.ios.service.state.unknown".localisedString, #imageLiteral(resourceName: "bulb-off"),self.name,self.self.accessory?.room?.name)
            }
        case .unknown:
            return ("RHKit.common.ios.service.state.unknown".localisedString, nil,self.name,self.self.accessory?.room?.name)
        }
    }

    /// The custom displayable characteristic types specific to Kilgo devices.
    enum KilgoCharacteristicTypes: String {
        case fadeRate = "7E536242-341C-4862-BE90-272CE15BD633"
    }

    /// The list of characteristics to display in the UI.
    var displayableCharacteristics: [HMCharacteristic] {
        let characteristicTypes = [HMCharacteristicTypePowerState,
                                   HMCharacteristicTypeBrightness,
                                   HMCharacteristicTypeHue,
                                   HMCharacteristicTypeSaturation,
                                   HMCharacteristicTypeTargetDoorState,
                                   HMCharacteristicTypeCurrentDoorState,
                                   HMCharacteristicTypeObstructionDetected,
                                   HMCharacteristicTypeTargetLockMechanismState,
                                   HMCharacteristicTypeCurrentLockMechanismState,
                                   KilgoCharacteristicTypes.fadeRate.rawValue]
        
        return characteristics.filter { characteristicTypes.contains($0.characteristicType) }
    }

}
