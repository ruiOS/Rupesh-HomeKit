//
//  RWTableHeaderFooterView.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

class RWTableHeaderFooterView: UITableViewHeaderFooterView {
    //MARK:- Intialisers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier:reuseIdentifier)
        //set cell Colors
        self.backgroundColor = AppColor.defaultBackGroundColor
        self.contentView.backgroundColor = AppColor.defaultBackGroundColor
        self.backgroundView?.backgroundColor = AppColor.defaultBackGroundColor
        //add separatorLine
        addSeparatorLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- SeparatorLine
    ///Separator Line for headerView
    var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = AppColor.separatorColor
        return separatorLine
    }()

    ///method used to add separator line for headerView
    func addSeparatorLine(){
        self.addSubview(separatorLine)
        separatorLine.leadingAnchor.constraint(equalTo: self.safeLeadingAnchor).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: self.safeTrailingAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: self.safeBottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
