//
//  AccessoryDetailController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///Controller used to show details of the accessories
class AccessoryDetailController: RWTableViewController {

    //MARK:- Data
    //tableView Identifiers
    ///Identifier for all cells in section 1
    let section1CellIdentifier: String = "section1"
    ///Identifier for all cells in section 2
    let section2CellIdentifier: String = "section2"
    ///Identifier for all cells in section 3
    let section3CellIdentifier: String = "section3"
    ///Identifier for header
    let sectionHeaderIdentifier: String = "SectionHeader"

    ///Service whose data is provided bt tableView
    var service: HMService?

    ///home in which the service exist
    var home: HMHome!

    //MARK:- Intialisers
    /// returns an object of AccessoryDetailController
    /// - Parameters:
    ///   - service: service for which the accessory details are shown
    ///   - home: home in which the service exists
    convenience init(withService service: HMService, inHome home: HMHome){
        self.init()
        self.service = service
        self.home = home
    }

    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //set notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name.ItemEdited, object: nil)

        //register tableView data
        tableView.register(DetailCell.self, forCellReuseIdentifier: section1CellIdentifier)
        tableView.register(DetailCell.self, forCellReuseIdentifier: section2CellIdentifier)
        tableView.register(DestructiveActionCell.self, forCellReuseIdentifier: section3CellIdentifier)
        tableView.register(RWTableHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: sectionHeaderIdentifier)

    }

    //MARK:- UITableViewDatasource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultCellHeight
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : Constants.defaultSectionHeaderView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: section1CellIdentifier) as? DetailCell ?? DetailCell(style: .value1, reuseIdentifier: section1CellIdentifier)
            switch indexPath.row {
            case 0:
                cell.setCell(key:LocalisedStrings.common_name,value:service?.name)
            case 1:
                cell.setCell(key:LocalisedStrings.detail_room,value:service?.accessory?.room?.name)
            default:
                cell.setCell(key:LocalisedStrings.detail_settings,value:"")
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: section1CellIdentifier) as? DetailCell ?? DetailCell(style: .default, reuseIdentifier: section1CellIdentifier)
            switch indexPath.row {
            case 0:
                cell.setCell(key:LocalisedStrings.detail_model,value:service?.accessory?.model,isCellSelectable:false)
            default:
                cell.setCell(key:LocalisedStrings.detail_firmwareVersion,value:service?.accessory?.firmwareVersion,isCellSelectable:false)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: section3CellIdentifier) as? DestructiveActionCell ?? DestructiveActionCell(style: .default, reuseIdentifier: section3CellIdentifier)
            cell.setCell(withText: LocalisedStrings.common_removeAccessory)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderIdentifier) as? RWTableHeaderFooterView ?? RWTableHeaderFooterView()
        return sectionHeaderView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch  indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let editDetailVC = EditServiceNameController(key: LocalisedStrings.common_name, forService: service!)
                navigationController?.pushViewController(editDetailVC, animated: true)
            case 1:
                let updateRoomVC = UpdateRoomController(withKey: LocalisedStrings.detail_room, forService: service!, inHome: home)
                navigationController?.pushViewController(updateRoomVC, animated: true)
            default:
                if let tempService = service{
                    let settingsController = SettingsController(forService: service!)
                    settingsController.service = tempService//SettingsController(forService: tempService)
                    navigationController?.pushViewController(settingsController, animated: true)
                }
                break
            }
        case 2:
            removeAccessory()
            break
        default:
            break
        }
    }

    //MARK:- Private functions

    ///Method used to reload the tableView
    @objc func reloadTableView(){
        tableView.reloadData()
    }

    ///method used to remove accessory
    private func removeAccessory(){
        //show alert to confirm removing accessory
        let alert = UIAlertController(title: LocalisedStrings.common_removeAccessory,
                                      message: LocalisedStrings.alert_areYouSureToRemoveAccessory,
                                      preferredStyle: .alert)
        //add action to remove accessory
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_remove, style: .destructive) { [unowned self]_ in
            ///current accessory
            if let accessory = self.service?.accessory{
                //accessory removal
                RWHomeManager.shared.removeAccessory(accessory, inHome: self.home) { (error) in
                    if let _ = error{
                        self.displayError(error: error!)
                    }
                    //reload data on removal
                    RWHomeManager.shared.reloadData()
                    //popViewController after removal of accessory as it don;t exist
                    self.navigationController?.popViewController(animated: true)
                    //Post notification as accessory is removed
                    NotificationCenter.default.post(name: .ItemDeleted, object: nil)
                }
            }
        })
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_cancel, style: .cancel))
        //present alert
        present(alert, animated: true)
    }

    /// Method used to display errors
    /// - Parameter error: error to be displayed
    private func displayError(error: Error){
        let alert = UIAlertController(title: LocalisedStrings.alert_error, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
