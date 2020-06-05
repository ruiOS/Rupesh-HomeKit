//
//  SettingsController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 05/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

class SettingsController: RWTableViewController {

    //MARK:- Data
    var service: HMService = HMService()

    let cellIdentifier = "Settingscell"

    var characteristics: [HMCharacteristic]{
        service.displayableCharacteristics
    }

    //MARK:- Intialisers
    convenience init(forService service: HMService){
        self.init()
        self.service = service
    }

    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SettingsCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    //MARK:- TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characteristics.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultCellHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SettingsCell ?? SettingsCell(style: .default, reuseIdentifier: cellIdentifier)
        if service.rhServiceType == .door{
            
        }
        return cell
    }

}

