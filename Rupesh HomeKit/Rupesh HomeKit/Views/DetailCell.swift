//
//  DetailCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

class DetailCell: RWHomeKitCell {

    //MARK:- Data
    
    let cellIconSize: CGFloat = 24

    var isCellSelectable: Bool = true {
        didSet{
            self.accessoryType  =  isCellSelectable ? .disclosureIndicator : .none
        }
    }

    //MARK:- Views

    private let selectedView = UIView()

    lazy var keyLabel: UILabel = self.createLabel()
    lazy var valueLabel: UILabel = self.createLabel()

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
        addViews()
    }

    //MARK:- cell default methods
    
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
    private func addViews(){
        self.contentView.addSubview(keyLabel)
        keyLabel.leadingAnchor.constraint(equalTo: contentView.safeLeadingAnchor, constant: 20).isActive = true
        keyLabel.topAnchor.constraint(equalTo: contentView.safeTopAnchor).isActive = true
        keyLabel.bottomAnchor.constraint(equalTo: contentView.safeBottomAnchor).isActive = true
        keyLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -10).isActive = true

        valueLabel.textAlignment = .right
        self.contentView.addSubview(valueLabel)
        valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        valueLabel.topAnchor.constraint(equalTo: contentView.safeTopAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: contentView.safeBottomAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 10).isActive = true

    }

    //MARK:- Internal Methods
    func setCell(key:String?,value:String?,isCellSelectable:Bool = true){
        keyLabel.text = key
        valueLabel.text = value
        self.isCellSelectable = isCellSelectable
    }

}
