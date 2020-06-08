//
//  EditServiceNameController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///
class EditServiceNameController: RWTableViewController {

    //MARK:- Data
    /// reuse identifier for RWTextFieldCell
    let cellReuseIdentifier = "RWTextFieldCell"

    ///value being edited
    var value: String = ""
    ///key of the value to be edited
    var key: String = ""
    ///service for which the value is being edited
    var service: HMService = HMService()

    //MARK:- Intialisers
    
    /// returns new object of EditServiceNameController
    /// - Parameters:
    ///   - key: key of the value to be edited
    ///   - service: service for which the value is being edited
    convenience init(key:String,forService service:HMService) {
        self.init()
        //set data
        self.service = service
        self.key = key
        self.value = service.name
    }

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(RWTextFieldCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.title = key
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Set value to have only one RWTextFieldCell
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? RWTextFieldCell ?? RWTextFieldCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        //set value for the cell
        cell.setCell(withText: value)
        //set updateServiceNameClosure
        cell.updateServiceNameClosure = {[unowned self](text) in
            self.value = text
            RWHomeManager.shared.updateServiceName(forService: self.service, toName: self.value)
        }
        return cell
    }

}
