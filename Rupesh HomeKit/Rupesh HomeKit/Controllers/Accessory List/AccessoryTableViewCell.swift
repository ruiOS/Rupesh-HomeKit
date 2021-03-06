//
//  AccessoryTableViewCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///Cell used to show and set primary characteristics of accessories
class AccessoryTableViewCell: UITableViewCell {

    //MARK:- Views
    ///cell contentview that stores all the contents in the cell
    private let cellContentView: UIView = {
        let tempView: UIView = UIView()
        tempView.layer.cornerRadius = Constants.cellContentViewCornerRadius
        tempView.layer.masksToBounds = true
        tempView.backgroundColor = AppColor.accessoryCellBackGroundColor
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    ///imageView that shows image of th accessories
    private let accessoryImageView: UIImageView = {
        let tempImageView: UIImageView = UIImageView()
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        return tempImageView
    }()

    ///Label That provides room name
    private lazy var roomNameLabel: UILabel = {
        let tempLabel: UILabel = createLabel()
        tempLabel.font = AppFonts.regularFont
        return tempLabel
    }()

    ///Label That provides accessory name
    private lazy var accessoryNameLabel: UILabel = {
        let tempLabel: UILabel = createLabel()
        tempLabel.numberOfLines = 2
        tempLabel.font = AppFonts.boldFont
        return tempLabel
    }()

    ///Label That provides accessory state
    private lazy var accessoryStateLabel: UILabel = {
        let tempLabel: UILabel = createLabel()
        tempLabel.font = AppFonts.regularFont
        return tempLabel
    }()

    ///Button used to show info of accessory
    private let infoButton: UIButton = {
        let tempButton = UIButton(type: .infoLight)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        return tempButton
    }()

    //Returns a label. Used for creating labels
    private func createLabel()->UILabel{
        let tempLabel: UILabel = UILabel()
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }

    //MARK:-Data

    ///Closure used to pass data and information between cell and tableView. Use this to present Viewcontrollerrs when infoButton is pressed
    var infoButtonPressedClosure: (()->Void)? = nil

    ///the default service  embedded to the cell
    var service: HMService?

    ///Multiplier for cellcontentView w.r.t. cell.contentView
    let cellRegularDimensionMultiplier: CGFloat = 0.8

    //MARK:- Intialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        intialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    ///set all the views
    private func intialSetup(){
        //set default cell properties
        self.contentView.backgroundColor = .clear
        self.backgroundColor = AppColor.defaultBackGroundColor

        //add cellContentView
        self.contentView.addSubview(cellContentView)
        cellContentView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        cellContentView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        cellContentView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: cellRegularDimensionMultiplier).isActive = true
        cellContentView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: cellRegularDimensionMultiplier).isActive = true

        //add accessoryImageView
        cellContentView.addSubview(accessoryImageView)
        accessoryImageView.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor,constant: 20).isActive = true
        accessoryImageView.heightAnchor.constraint(equalToConstant: Constants.accessoryImageHeight).isActive = true
        accessoryImageView.widthAnchor.constraint(equalToConstant: Constants.accessoryImageHeight).isActive = true
        accessoryImageView.centerYAnchor.constraint(equalTo: cellContentView.centerYAnchor).isActive = true

        //add roomNameLabel
        cellContentView.addSubview(roomNameLabel)
        roomNameLabel.leadingAnchor.constraint(equalTo: accessoryImageView.trailingAnchor,constant: 5).isActive = true
        roomNameLabel.topAnchor.constraint(equalTo: cellContentView.topAnchor).isActive = true
        roomNameLabel.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor,constant: -25).isActive = true
        roomNameLabel.heightAnchor.constraint(equalTo: cellContentView.heightAnchor, multiplier: 0.3).isActive = true

        //add accessoryNameLabel
        cellContentView.addSubview(accessoryNameLabel)
        accessoryNameLabel.leadingAnchor.constraint(equalTo: accessoryImageView.trailingAnchor,constant: 5).isActive = true
        accessoryNameLabel.topAnchor.constraint(equalTo: roomNameLabel.bottomAnchor).isActive = true
        accessoryNameLabel.trailingAnchor.constraint(equalTo: roomNameLabel.trailingAnchor).isActive = true
        accessoryNameLabel.heightAnchor.constraint(equalTo: cellContentView.heightAnchor, multiplier: 0.4).isActive = true

        //add accessoryStateLabel
        cellContentView.addSubview(accessoryStateLabel)
        accessoryStateLabel.leadingAnchor.constraint(equalTo: accessoryImageView.trailingAnchor,constant: 5).isActive = true
        accessoryStateLabel.topAnchor.constraint(equalTo: accessoryNameLabel.bottomAnchor).isActive = true
        accessoryStateLabel.trailingAnchor.constraint(equalTo: roomNameLabel.trailingAnchor).isActive = true
        accessoryStateLabel.heightAnchor.constraint(equalTo: cellContentView.heightAnchor, multiplier: 0.3).isActive = true

        //set infoButton
        infoButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        let infoButtonSize: CGFloat = 20
        //add infoButton
        cellContentView.addSubview(infoButton)
        infoButton.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor,constant: -5).isActive = true
        infoButton.bottomAnchor.constraint(equalTo: cellContentView.bottomAnchor,constant: -5).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: infoButtonSize).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: infoButtonSize).isActive = true

    }
    //MARK:- Cell HeighLight and bounce animations
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false , animated: false)
        //set actions on selection
        if selected{
            //set animation
            animateCellBounce()
            //set state switch
            switchState()
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        return
    }

    //MARK:- Local Functions

    ///Called when infoButton is pressed
    @objc private func infoButtonPressed(){
        // call infoButtonPressedClosure
        infoButtonPressedClosure?()
    }

    ///use it switch state of the accessory
    private func switchState(){
        //Primary characteristic of the service
        if let characteristic = service?.primaryControlCharacteristic,
            //get primary characteristic value
            let value = characteristic.value as? Bool {
            // Write the new value to HomeKit.
            characteristic.writeValue(!value) {[unowned self] error in
                //set Cell new Values
                self.setCell(service: self.service)
                if let _ = error{
                    //set error to sccessory state
                    self.accessoryStateLabel.text = LocalisedStrings.error_changeStateFailed
                }
            }
        }
    }
    
    ///cell bounce animation on selection
    private func animateCellBounce(){
        UIView.animate(withDuration: 0.1, delay: 0.1, animations: {[unowned self] in
            //shrink cell contentView Size
            self.cellContentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { [unowned self] (_)  in
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {[unowned self] in
                //make contentView Size normal
                self.cellContentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }

    //Internal Functions
    
    /// Method used to set cell
    /// - Parameter service: the service that is needed to be displayed
    func setCell(service: HMService?) {
        //set default service
        self.service = service
        //set cell data using serviceDataTuple
        (accessoryStateLabel.text,accessoryImageView.image,accessoryNameLabel.text,roomNameLabel.text) = service?.serviceDataTuple ?? ("",UIImage(),"","")
    }


}
