//
//  RWTextFieldCell.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

///Cell with  textField
class RWTextFieldCell:RWHomeKitCell,UITextFieldDelegate{
    //MARK:- Data

    ///closure used to update serviceName on edit
    var updateServiceNameClosure: ((String)->Void)? = nil

    ///name of the service
    private var nameText: String = ""
    
    //MARK:- View

    ///Textfield used to edit name
    private let textField: UITextField = {
        let tempTextfield: UITextField = UITextField()
        tempTextfield.translatesAutoresizingMaskIntoConstraints = false
        tempTextfield.clearButtonMode = .whileEditing
        tempTextfield.returnKeyType = .done
        return tempTextfield
    }()
    
    //MARK:- Intialisers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //set text Field
        setTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- setViews
    
    /// Method used to set textField
    private func setTextField(){
        //set delegate
        textField.delegate = self
        //add textField
        self.contentView.addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: 20).isActive = true
        textField.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }

    //MARK:- Internal functions
    /// method used to set data to cell
    /// - Parameter text: text to be displayed in textField
    func setCell(withText text: String){
        textField.text = text
        self.nameText = text
    }

    //MARK:- UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        //set textField data to nameText
        nameText = textField.text ?? ""
        //update name of the service after edit
        updateServiceNameClosure?(nameText)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //resign first responder when done is pressed
        textField.resignFirstResponder()
        return true
    }

}
