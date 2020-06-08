//
//  SettingsController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 05/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///Settings controller used to change characteristic  of the service
class SettingsController: RWTableViewController,HMAccessoryDelegate {

    //MARK:- Data
    ///service for which the characteristics need to becdisplayed and updated
    var service: HMService = HMService()

    ///default identifier for Settingscell
    let cellIdentifier = "Settingscell"

    //MARK:- Intialisers
    /// returns an object of SettingsController
    /// - Parameter service: service for which the characteristics need to becdisplayed and updated
    convenience init(forService service: HMService){
        self.init()
        self.service = service
    }

    //MARK:- ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //set accessory delegate
        service.accessory?.delegate = self
        //set identiers for cells of tableView
        tableView.register(SettingsCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    //MARK:- TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get count of service characteristics
        service.characteristics.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //set tableView Cell's hwight to automatic dimension
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SettingsCell ?? SettingsCell(style: .default, reuseIdentifier: cellIdentifier)
        let currentCharacteristic = service.characteristics[indexPath.row]
        cell.setCell(characteristic: currentCharacteristic,isPrimaryControlCharacteristic: service.primaryControlCharacteristic == currentCharacteristic)
        cell.errorHandler = { [unowned self]error in
            let alert = UIAlertController(title: "RHKit.common.ios.error".localisedString, message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "RHKit.common.ios.error.ok".localisedString, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return cell
    }

    //MARK:- HMAccessoryDelegate
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        guard service == self.service else { return }
        
        // Find the cell that displays this characteristic.
        guard let row = service.characteristics.firstIndex(of: characteristic),
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SettingsCell
            else { return }
        let currentCharacteristic = service.characteristics[row]
        ///check if the cell's characteristic is the primary characteristic
        let isPrimaryCharacteristic = service.primaryControlCharacteristic == currentCharacteristic

        if isPrimaryCharacteristic{
            // post notifiaction if primary characteristic is updated
            NotificationCenter.default.post(name: .ItemEdited, object: nil)
        }
        // Set cell after upadting characteristics
        cell.setCell(characteristic: currentCharacteristic, isPrimaryControlCharacteristic: isPrimaryCharacteristic)
    }

}

