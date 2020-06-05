//
//  RWHomeKitCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

class RWHomeKitCell: UITableViewCell {

    //MARK:- Intialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = AppColor.cellBackGroundColor
        addSeparatorLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- SeparatorLine
    var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = AppColor.separatorColor
        return separatorLine
    }()

    func addSeparatorLine(){
        self.addSubview(separatorLine)
        separatorLine.leadingAnchor.constraint(equalTo: self.safeLeadingAnchor).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: self.safeTrailingAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: self.safeBottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
