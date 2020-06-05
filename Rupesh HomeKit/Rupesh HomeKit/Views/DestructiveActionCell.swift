//
//  DestructiveActionCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

class DestructiveActionCell: RWHomeKitCell {

    //MARK:- intialisers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addDestructiveLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- destructiveLabel
    private let destructiveLabel: UILabel = {
        let tempLabel: UILabel = UILabel()
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.textColor = AppColor.appRedColor
        tempLabel.font = AppFonts.regularFont
        tempLabel.textAlignment = .center
        return tempLabel
    }()

    func addDestructiveLabel(){
        self.contentView.addSubview(destructiveLabel)
        destructiveLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        destructiveLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        destructiveLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        destructiveLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }

    //MARK:- Local Functions
    func setCell(withText text:String?){
        destructiveLabel.text = text
    }

}
