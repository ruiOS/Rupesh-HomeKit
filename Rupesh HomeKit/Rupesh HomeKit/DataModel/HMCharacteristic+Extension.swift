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
        switch characteristicType {
        case HMCharacteristicTypeCurrentLockMechanismState:
            return [LocalisedStrings.state_unsecured,
                    LocalisedStrings.state_secured,
                    LocalisedStrings.state_jammed,
                    LocalisedStrings.state_unknown]
        case HMCharacteristicTypeTargetLockMechanismState:
            return [LocalisedStrings.state_notLocked,
                    LocalisedStrings.state_locked]
        case HMCharacteristicTypeCurrentDoorState:
            return [LocalisedStrings.state_open,
                    LocalisedStrings.state_closed,
                    LocalisedStrings.state_opening,
                    LocalisedStrings.state_closing,
                    LocalisedStrings.state_stopped]
        case HMCharacteristicTypeTargetDoorState:
            return [LocalisedStrings.state_open,
                    LocalisedStrings.state_closed]
        case HMCharacteristicTypeRotationDirection:
            return [LocalisedStrings.state_clockwise,
                    LocalisedStrings.state_counterClockwise]
        default:
            return []
        }
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
