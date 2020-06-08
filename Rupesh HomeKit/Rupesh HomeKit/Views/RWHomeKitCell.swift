//
//  RWHomeKitCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

///Cell that consists of default properties of cells in the app
class RWHomeKitCell: UITableViewCell {

    //MARK:- Intialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //set colors
        self.contentView.backgroundColor = .clear
        self.backgroundColor = AppColor.cellBackGroundColor
        //add Seperator Line
        addSeparatorLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- SeparatorLine
    ///Separator Line for cell
    private var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = AppColor.separatorColor
        return separatorLine
    }()

    ///method used to add separator line for cell
    private func addSeparatorLine(){
        //add Separator Line
        self.addSubview(separatorLine)
        separatorLine.leadingAnchor.constraint(equalTo: self.safeLeadingAnchor).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: self.safeTrailingAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: self.safeBottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
