//
//  SettingsCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 05/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

class SettingsCell: RWHomeKitCell {

    //MARK:- Views
    lazy var keyLabel: UILabel = createLabel()
    lazy var valueLabel: UILabel = createLabel()

    var getSliderValue : ((Int32)->Void)?


    let slider: UISlider = {
        let tempSlider = UISlider()
        tempSlider.translatesAutoresizingMaskIntoConstraints = false
        return tempSlider
    }()

    let toggleSwitch: UISwitch = {
        let tempSwitch = UISwitch()
        tempSwitch.translatesAutoresizingMaskIntoConstraints = false
        return tempSwitch
    }()

    let segmentedControl: UISegmentedControl = {
        let tempSegmentedControl = UISegmentedControl()
        tempSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return tempSegmentedControl
    }()

    private func createLabel()->UILabel{
        let tempLabel: UILabel = UILabel()
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }

    //MARK:- Data
    let regularValueLabelWidthConstant: CGFloat = 100
    let sliderValueLabelSizeConstant: CGFloat = 20
    var valueLabelWidthConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var valueLabelHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var valueLabelYAxisConstraint: NSLayoutConstraint = NSLayoutConstraint()

    //MARK:- Intialiser
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        intialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func intialSetUp(){
        let defaultHeightMultiplier: CGFloat = 0.8
        let viewSpacing: CGFloat = 20
        let secondaryViewconstantWidth: CGFloat = 130

        self.contentView.addSubview(keyLabel)
        keyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: viewSpacing).isActive = true
        keyLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier).isActive = true
        keyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        keyLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor,constant: -(viewSpacing/2)).isActive = true

        self.contentView.addSubview(slider)
        slider.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -viewSpacing).isActive = true
        slider.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier).isActive = true
        slider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        slider.widthAnchor.constraint(equalToConstant: secondaryViewconstantWidth).isActive = true

        self.contentView.addSubview(toggleSwitch)
        toggleSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -viewSpacing).isActive = true
        toggleSwitch.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier).isActive = true
        toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        toggleSwitch.widthAnchor.constraint(equalToConstant: secondaryViewconstantWidth).isActive = true

        self.contentView.addSubview(segmentedControl)
        segmentedControl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -viewSpacing).isActive = true
        segmentedControl.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier).isActive = true
        segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: secondaryViewconstantWidth).isActive = true

        self.contentView.addSubview(valueLabel)
        valueLabelWidthConstraint = valueLabel.widthAnchor.constraint(equalToConstant: regularValueLabelWidthConstant)
        valueLabelHeightConstraint = valueLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: defaultHeightMultiplier)
        valueLabelYAxisConstraint = valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        valueLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor,constant: -(viewSpacing/2)).isActive = true

        valueLabelWidthConstraint.isActive = true
        valueLabelHeightConstraint.isActive = true
        valueLabelYAxisConstraint.isActive = true

    }

    //MARK:- local methods
    private func hideViews(){
        //Hide secondary views
        slider.isHidden = true
        toggleSwitch.isHidden = true
        segmentedControl.isHidden = true
        valueLabel.isHidden = true
    }

    private func setConstraintsFalse(){
        valueLabelWidthConstraint.isActive = false
        valueLabelHeightConstraint.isActive = false
        valueLabelYAxisConstraint.isActive = false
    }

    private func setConstrintsTrue(){
        valueLabelWidthConstraint.isActive = true
        valueLabelHeightConstraint.isActive = true
        valueLabelYAxisConstraint.isActive = true
    }

    //MARK:- Set Views
    func setSlider(key:String,minValue: CGFloat,maxValue: CGFloat, value: CGFloat){
        hideViews()
        setConstraintsFalse()

        valueLabelWidthConstraint = valueLabel.widthAnchor.constraint(equalToConstant: sliderValueLabelSizeConstant)
        valueLabelHeightConstraint = valueLabel.heightAnchor.constraint(equalToConstant: sliderValueLabelSizeConstant)
        valueLabelYAxisConstraint = valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5)

        setConstrintsTrue()

        slider.isHidden = false
        slider.addTarget(self, action: #selector(sliderDidChangeValue(sender:)), for: [.touchUpInside,.touchUpOutside])
        slider.addTarget(self, action: #selector(sliderWillChangeValue(sender:)), for: .allEvents)

    }

    //MARK:- Slider Delegates
    @objc func sliderDidChangeValue(sender: UISlider){
        let value = Int(sender.value)
        valueLabel.text = "\(value)"
        getSliderValue?(Int32(value))
    }

    @objc func sliderWillChangeValue(sender: UISlider){
        valueLabel.text = "\(Int(sender.value))"
    }

}
