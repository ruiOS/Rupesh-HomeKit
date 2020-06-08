//
//  HMCharacteristic+Extension.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import HomeKit

extension HMCharacteristic {

    ///returns state names the object supports
    var stateNames: [String] {
        var characteristicStrings: [String] = [String]()
        switch characteristicType {
        case HMCharacteristicTypeCurrentLockMechanismState:
            characteristicStrings = ["RHKit.common.ios.service.state.unsecured",
                    "RHKit.common.ios.service.state.secured",
                    "RHKit.common.ios.service.state.jammed",
                    "RHKit.common.ios.service.state.unknown"]
        case HMCharacteristicTypeTargetLockMechanismState:
            characteristicStrings = ["RHKit.common.ios.service.state.notLocked",
            "RHKit.common.ios.service.state.locked"]
        case HMCharacteristicTypeCurrentDoorState:
            characteristicStrings = ["RHKit.common.ios.service.state.open",
                    "RHKit.common.ios.service.state.closed",
                    "RHKit.common.ios.service.state.opening",
                    "RHKit.common.ios.service.state.closing",
                    "RHKit.common.ios.service.state.stopped"]
        case HMCharacteristicTypeTargetDoorState:
            characteristicStrings = ["RHKit.common.ios.service.state.open",
            "RHKit.common.ios.service.state.closed"]
        case HMCharacteristicTypeRotationDirection:
            characteristicStrings = ["RHKit.common.ios.service.state.clockwise",
                "RHKit.common.ios.service.state.counterClockWise"]
        default: break
        }
        return characteristicStrings.map{$0.localisedString}
    }

    /// Indicates if you can write to the characteristic.
    var isWriteable: Bool {
        return properties.contains(HMCharacteristicPropertyWritable)
    }

    /// Indicates that the characteristic value is a number.
    var isNumeric: Bool {
        switch metadata?.format {
        case HMCharacteristicMetadataFormatUInt8,
             HMCharacteristicMetadataFormatUInt16,
             HMCharacteristicMetadataFormatUInt32,
             HMCharacteristicMetadataFormatUInt64,
             HMCharacteristicMetadataFormatInt,
             HMCharacteristicMetadataFormatFloat:
            return true
        default:
            return false
        }
    }

    /// Indicates that the characteristic value is a Boolean.
    var isBool: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatBool
    }

    ///Struct that provides values to be displayed in a slider
    struct SliderValues {
        ///Maximum Value that can be assigned to the slider
        var max: Float
        ///Minimum Value that can be assigned to the slider
        var min: Float
        ///Current Value of the slider
        var current: Float

        /// returns an object of SliderValues
        /// - Parameter metaData: metaData
        /// - Parameter value: value of the slider
        init(metaData: HMCharacteristicMetadata?,value: Any?) {
            //set Data
            max = metaData?.maximumValue?.floatValue ?? 0
            min = metaData?.minimumValue?.floatValue ?? 1
            current = (value as? NSNumber)?.floatValue ?? 0
        }
    }

    ///retruns a struct containing properties for a slider
    var sliderValue: SliderValues {
        SliderValues(metaData: metadata, value: value)
    }

}
