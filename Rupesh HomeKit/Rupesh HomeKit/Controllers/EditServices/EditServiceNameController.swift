//
//  EditServiceNameController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

class EditServiceNameController: RWTableViewController {

    let cellReuseIdentifier = "RWTextFieldCell"

    var value: String = ""
    var key: String = ""
    var service: HMService = HMService()

    convenience init(key:String,forService service:HMService) {
        self.init()
        self.service = service
        self.key = key
        self.value = service.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(RWTextFieldCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.title = key
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? RWTextFieldCell ?? RWTextFieldCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        cell.setCell(withText: value)
        cell.updateServiceNameClosure = {[unowned self](text) in
            self.value = text
            RWHomeManager.shared.updateServiceName(forService: self.service, toName: self.value)
        }
        return cell
    }

}
