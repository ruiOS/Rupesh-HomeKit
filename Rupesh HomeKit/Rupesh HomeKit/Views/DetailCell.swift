//
//  DetailCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

///Cell used to show details of characteristics
class DetailCell: RWHomeKitCell {

    //MARK:- Data
    ///returns if cell is selectable
    var isCellSelectable: Bool = true {
        didSet{
            //set .disclosureIndicator accessory for selectable cell
            self.accessoryType  =  isCellSelectable ? .disclosureIndicator : .none
        }
    }

    //MARK:- Views

    ///Label that shows key of the service
    lazy var keyLabel: UILabel = self.createLabel()
    ///Label that shows value of the service
    lazy var valueLabel: UILabel = self.createLabel()

    ///method used to get a new Label
    private func createLabel()->UILabel{
        let tempLabel: UILabel = UILabel()
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.font = AppFonts.regularFont
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }

    //MARK:- Intialiser
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addViews
        addViews()
    }

    //MARK:- cell Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        if isCellSelectable{
            super.setSelected(selected, animated: animated)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:- Local methods
    /// method used to add Views to cell
    private func addViews(){
        //add keyLabel
        self.contentView.addSubview(keyLabel)
        keyLabel.leadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor, constant: 20).isActive = true
        keyLabel.topAnchor.constraint(equalTo: contentView.safeTopAnchor).isActive = true
        keyLabel.bottomAnchor.constraint(equalTo: contentView.safeBottomAnchor).isActive = true
        keyLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10).isActive = true

        //set valueLabel
        valueLabel.textAlignment = .right
        //add valueLabel
        self.contentView.addSubview(valueLabel)
        valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        valueLabel.topAnchor.constraint(equalTo: contentView.safeTopAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: contentView.safeBottomAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10).isActive = true

    }

    //MARK:- Internal Methods
    /// method used to set data of cell
    /// - Parameters:
    ///   - key: key of the service
    ///   - value: value of the service
    ///   - isCellSelectable: returns if the cell is selectable
    func setCell(key:String?,value:String?,isCellSelectable:Bool = true){
        //set cell values
        keyLabel.text = key
        valueLabel.text = value
        self.isCellSelectable = isCellSelectable
    }

}
