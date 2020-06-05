//
//  RWTextFieldCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

class RWTextFieldCell:RWHomeKitCell,UITextFieldDelegate{
    //MARK:- Data

    var updateServiceNameClosure: ((String)->Void)? = nil

    var descriptionText: String = ""
    
    //MARK:- Viewa

    let textField: UITextField = {
        let tempTextfield: UITextField = UITextField()
        tempTextfield.translatesAutoresizingMaskIntoConstraints = false
        tempTextfield.clearButtonMode = .whileEditing
        tempTextfield.returnKeyType = .done
        return tempTextfield
    }()
    
    //MARK:- Intialisers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- setViews
    private func setTextField(){
        textField.delegate = self
        self.contentView.addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: 20).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }

    //MARK:- Internal functions
    func setCell(withText text: String){
        textField.text = text
        self.descriptionText = text
    }

    //MARK:- UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        descriptionText = textField.text ?? ""
        updateServiceNameClosure?(descriptionText)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
