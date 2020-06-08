//
//  SettingsCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 05/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///Cell used to show and update characteristics of a service
class SettingsCell: RWHomeKitCell {

    //MARK:- Views
    ///label that shows name of the characteristic
    private lazy var keyLabel: UILabel = createLabel()
    
    ///label that displays value of the characteristic
    private lazy var valueLabel: UILabel = {
        let tempLabel = createLabel()
        tempLabel.adjustsFontForContentSizeCategory = true
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.textAlignment = .right
        return tempLabel
    }()

    ///slider that displays and used to edit numeric value of the characteristic
    private let valueSlider: UISlider = {
        let tempSlider = UISlider()
        tempSlider.minimumValue = 0
        tempSlider.maximumValue = 1
        tempSlider.minimumTrackTintColor = AppColor.accessoryCellBackGroundColor
        tempSlider.translatesAutoresizingMaskIntoConstraints = false
        return tempSlider
    }()

    ///slider that displays and used to edit boolean value of the characteristic
    private let toggleSwitch: UISwitch = {
        let tempSwitch = UISwitch()
        tempSwitch.contentMode = .right
        tempSwitch.translatesAutoresizingMaskIntoConstraints = false
        return tempSwitch
    }()

    ///slider that displays and used to edit Integer value of the characteristic with stated
    private let segmentedControl: UISegmentedControl = {
        let tempSegmentedControl = UISegmentedControl()
        tempSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return tempSegmentedControl
    }()

    //method used to create and add new label
    private func createLabel()->UILabel{
        let tempLabel: UILabel = UILabel()
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }

    //MARK:- Data

    ///characteristic the cell displays data of
    private var characteristic: HMCharacteristic = HMCharacteristic()

    ///returns if the present controlCharacteristic is the primary primaryControlCharacteristic
    private var isPrimaryControlCharacteristic: Bool = false

    //Constants
    ///default height multiplier of the views in the cell with respect to contentView of cell
    private let defaultHeightMultiplier: CGFloat = 0.8

    ///normal width  of the cell when slider is not present
    private let regularValueLabelWidthConstant: CGFloat = 100

    ///height multiplier of the valueLabel and slider in the cell with respect to contentView of cell
    private let subTitleHeightMultiplier: CGFloat = 0.4

    //Constraints
    ///value label's height constraint
    private var valueLabelHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    ///value label's Y axis constraint
    private var valueLabelYAxisConstraint: NSLayoutConstraint = NSLayoutConstraint()
    ///contentView's height anchor. Use it to change height of the cell
    private var contentViewHeightAnchor: NSLayoutConstraint = NSLayoutConstraint()

    //Closures
    ///closure that handles errors
    var errorHandler:((Error?)->Void)? = nil

    //MARK:- Intialiser
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        intialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// method used to set up views after intialisation
    private func intialSetUp(){
        //set cell
        self.selectionStyle = .none

        //set frame constants
        let viewSpacing: CGFloat = 20
        let secondaryViewconstantWidth: CGFloat = 160

        //set delegates
        setSliderDelegate()
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChangeValue(sender:)), for: .valueChanged)
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchDidChangeValue(sender: )), for: .valueChanged)

        //set contentViewHeight Anchor
        contentViewHeightAnchor = contentView.heightAnchor.constraint(equalToConstant: 60)
        contentViewHeightAnchor.priority = UILayoutPriority(999)

        //add keyLabel
        self.contentView.addSubview(keyLabel)
        keyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: viewSpacing).isActive = true
        keyLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier).isActive = true
        keyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        keyLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor,constant: -(viewSpacing/2)).isActive = true

        //add valueSlider
        self.contentView.addSubview(valueSlider)
        valueSlider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -viewSpacing).isActive = true
        valueSlider.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: 0.4).isActive = true
        valueSlider.topAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        valueSlider.widthAnchor.constraint(equalToConstant: secondaryViewconstantWidth).isActive = true

        //add toggleSwitch
        self.contentView.addSubview(toggleSwitch)
        toggleSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -viewSpacing).isActive = true
        toggleSwitch.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier).isActive = true
        toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        toggleSwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true

        //add segmentedControl
        self.contentView.addSubview(segmentedControl)
        segmentedControl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -viewSpacing).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: secondaryViewconstantWidth).isActive = true

        //add valueLabel
        self.contentView.addSubview(valueLabel)
        valueLabel.widthAnchor.constraint(equalToConstant: regularValueLabelWidthConstant).isActive = true
        valueLabelHeightConstraint = valueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier)
        valueLabelYAxisConstraint = valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -viewSpacing).isActive = true

        valueLabelHeightConstraint.isActive = true
        valueLabelYAxisConstraint.isActive = true

    }

    //MARK:- local methods
    /// method used to hide all views that are designed to display characterstic value
    private func hideDisplayValueViews(){
        //Hide secondary views
        valueSlider.isHidden = true
        toggleSwitch.isHidden = true
        segmentedControl.isHidden = true
        valueLabel.isHidden = true
    }
    
    /// method used to set valueLabel's secondary constraints false
    private func setConstraintsFalse(){
        valueLabelHeightConstraint.isActive = false
        valueLabelYAxisConstraint.isActive = false
    }

    /// method used to set valueLabel's secondary constraints true
    private func setConstraintsTrue(){
        valueLabelHeightConstraint.isActive = true
        valueLabelYAxisConstraint.isActive = true
    }

    /// Method used to set text for value label
    /// - Parameter text: text to be set, "-" is set if text is nil
    private func setValueLabel(withText text: String? = nil){
        //set constraints
        valueLabelYAxisConstraint = valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        valueLabelHeightConstraint = valueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier)
        //set text
        if let stringvalue:String = text{
            valueLabel.text = stringvalue
        }else{
            valueLabel.text = "-"
        }
        //display value label
        valueLabel.isHidden = false
    }
    
    /// set views for slider Compatable characteristic. Ideally sets value label and slider
    private func setViewsForSliderComapatableCharacteristic(){
        //set value label constraints
        valueLabelYAxisConstraint = valueLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor)
        valueLabelHeightConstraint = valueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: subTitleHeightMultiplier)
        //display views
        valueSlider.isHidden = false
        valueLabel.isHidden = false
        //set user Interaction
        valueSlider.isUserInteractionEnabled = characteristic.isWriteable
        //set contentViewHeightAnchor
        contentViewHeightAnchor.isActive = true
        //set Values to the views
        valueSlider.minimumValue = characteristic.sliderValue.min
        valueSlider.maximumValue = characteristic.sliderValue.max
        valueSlider.value = characteristic.sliderValue.current
        setSliderValue(withSlider: valueSlider)
    }
    
    /// used to set slider Value to ValueLabel
    /// - Parameter currentSlider: provides slider whose value needed to be updated to value label
    private func setSliderValue(withSlider currentSlider: UISlider){
        if currentSlider.difference > 10{//check if decimal point is needed
            //set valuelabel's text without decimal point
            valueLabel.text = "\(Int32(currentSlider.value.roundedValue(forSlider: currentSlider)))"
        }else{
            //set valuelabel's text with decimal point
            valueLabel.text = "\(currentSlider.value.roundedValue(forSlider: currentSlider))"
        }
    }
    
    /// Updates characteristic on edit
    /// - Parameter value: value to be written to the characteristic
     private func updateCharacteristic(withValue value: Any){
         characteristic.writeValue(value) { [weak self](error) in
            //handle error
             if let _ = error{
                 self?.errorHandler?(error)
             }else{
                //post notification if primary characteristic
                 if let primaryControlCharacteristic = self?.isPrimaryControlCharacteristic, primaryControlCharacteristic{
                     NotificationCenter.default.post(name: .ItemEdited, object: nil)
                 }
             }
         }
     }


    //MARK:- Internal methods

    /// method used to set data in the cell
    /// - Parameters:
    ///   - characteristic: default characteristoc for which the values are displayed
    ///   - isPrimaryControlCharacteristic: value that give whether the cuurent characteristic is the primaryControlCharacteristic
    func setCell(characteristic: HMCharacteristic,isPrimaryControlCharacteristic: Bool){
        //set global data
        self.characteristic = characteristic
        self.isPrimaryControlCharacteristic = isPrimaryControlCharacteristic
        //set cell display default
        self.hideDisplayValueViews()
        self.setConstraintsFalse()
        contentViewHeightAnchor.isActive = false

        /// accessory of the service
        guard let accessory = characteristic.service?.accessory else {
            //set key label empty
            self.keyLabel.text = "-"
            return
        }
        //set name
        keyLabel.text = characteristic.metadata?.manufacturerDescription ?? characteristic.localizedDescription
        //check whether the accessory is reachable
        if !accessory.isReachable{
            //set value label empty
            setValueLabel()
        }else{
            //check whether the characteristic is boolean
            if let boolValue: Bool = characteristic.value as? Bool, characteristic.isBool{
                //set toggleSwitch
                toggleSwitch.isHidden = false
                toggleSwitch.isOn = boolValue
                toggleSwitch.isUserInteractionEnabled = characteristic.isWriteable
            }else if let intValue: Int = characteristic.value as? Int{ //check whether the characteristic is Int
                if !characteristic.stateNames.isEmpty{ // check if segmentedControl and label Compatiable
                    if characteristic.isWriteable{ //check if segmentedControl Compatiable
                        //set segmented control
                        segmentedControl.isHidden = false
                        segmentedControl.isUserInteractionEnabled = true
                        segmentedControl.removeAllSegments()
                        for index in 0...(characteristic.stateNames.count - 1) {
                            let name = characteristic.stateNames[index]
                            segmentedControl.insertSegment(withTitle: name, at: index, animated: false)
                            segmentedControl.selectedSegmentIndex = intValue
                        }
                    }else{
                        //set label
                        if let selectedSegment = characteristic.value as? Int{//set value if present as int orelse set empty value
                            setValueLabel(withText: characteristic.stateNames[selectedSegment])
                        }else{
                            setValueLabel()
                        }
                    }
                }else if (characteristic.isNumeric){ //check whether the characteristic is numeric
                    //set slider
                    setViewsForSliderComapatableCharacteristic()
                }
            } else if characteristic.value is Float || characteristic.value is NSNumber, (characteristic.stateNames.isEmpty && characteristic.isNumeric) { //check whether the characteristic is slider compatiable
                //set slider
                setViewsForSliderComapatableCharacteristic()
            }
            else{
                //set value label if characteristic is not compatable with present Views
                setValueLabel(withText: characteristic.value as? String)
            }
        }
        //set constraints to true
        self.setConstraintsTrue()
    }

    //MARK:- Set Delegates
    private func setSliderDelegate(){
        valueSlider.addTarget(self, action: #selector(sliderDidChangeValue(sender:)), for: [.touchUpInside,.touchUpOutside])
        valueSlider.addTarget(self, action: #selector(sliderDidSlide), for: .allEvents)
    }

    //MARK:- Slider Delegates

    /// set changes when slider value is changed
    /// - Parameter sender: slider whose value is changed
    @objc func sliderDidChangeValue(sender: UISlider){
        let roundedValue = sender.value.roundedValue(forSlider: sender)
        setSliderValue(withSlider: sender)
        updateCharacteristic(withValue: roundedValue)
    }
    
    /// set changes when slider value is being slided
    /// - Parameter sender: slider whose value is changed
    @objc func sliderDidSlide(sender: UISlider){
        setSliderValue(withSlider: sender)
    }

    //MARK:- UISegmentedControlDelegate
    /// set changes when segmentedControl value is changed
    /// - Parameter sender: segmentedControl whose value is changed
    @objc func segmentedControlDidChangeValue(sender: UISegmentedControl){
        updateCharacteristic(withValue: sender.selectedSegmentIndex)
    }

    //MARK:- UISwitchDelegate
    /// set changes when switch value is changed
    /// - Parameter sender: sender whose value is changed
    @objc func toggleSwitchDidChangeValue(sender: UISwitch){
        updateCharacteristic(withValue: sender.isOn)
    }

}
