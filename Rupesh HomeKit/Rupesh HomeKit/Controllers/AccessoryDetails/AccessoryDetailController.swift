//
//  AccessoryDetailController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

class AccessoryDetailController: RWTableViewController {

    var isFirstTimeLoading: Bool = true

    let section1CellIdentifier: String = "section1"
    let section2CellIdentifier: String = "section2"
    let section3CellIdentifier: String = "section3"
    let sectionHeaderIdentifier: String = "SectionHeader"
    
    var service: HMService?
    var home: HMHome!

    //MARK:- Intialisers
    convenience init(withService service: HMService, inHome home: HMHome){
        self.init()
        self.service = service
        self.home = home
    }

    //MARK:- ViewLifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstTimeLoading{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name.ItemEdited, object: nil)

        isFirstTimeLoading = false

        tableView.register(DetailCell.self, forCellReuseIdentifier: section1CellIdentifier)
        tableView.register(DetailCell.self, forCellReuseIdentifier: section2CellIdentifier)
        tableView.register(DestructiveActionCell.self, forCellReuseIdentifier: section3CellIdentifier)
        tableView.register(RWTableHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: sectionHeaderIdentifier)

        // Do any additional setup after loading the view.
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
                cell.setCell(key:"RHKit.common.ios.name".localisedString,value:service?.name)
            case 1:
                cell.setCell(key:"RHKit.common.ios.room".localisedString,value:service?.accessory?.room?.name)
            default:
                cell.setCell(key:"RHKit.common.ios.settings".localisedString,value:"")
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: section1CellIdentifier) as? DetailCell ?? DetailCell(style: .default, reuseIdentifier: section1CellIdentifier)
            switch indexPath.row {
            case 0:
                cell.setCell(key:"RHKit.common.ios.model".localisedString,value:service?.accessory?.model,isCellSelectable:false)
            default:
                cell.setCell(key:"RHKit.common.ios.firmWareVersion".localisedString,value:service?.accessory?.firmwareVersion,isCellSelectable:false)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: section3CellIdentifier) as? DestructiveActionCell ?? DestructiveActionCell(style: .default, reuseIdentifier: section3CellIdentifier)
            cell.setCell(withText: "RHKit.common.ios.removeAccessory".localisedString)
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
                let editDetailVC = EditServiceNameController(key: "RHKit.common.ios.name".localisedString, forService: service!)
                navigationController?.pushViewController(editDetailVC, animated: true)
            case 1:
                let updateRoomVC = UpdateServiceRoomController(withKey: "RHKit.common.ios.room".localisedString, forService: service!, inHome: home)
                navigationController?.pushViewController(updateRoomVC, animated: true)
            default:
                if let tempService = service{
                    let settingcController = SettingsController(forService: service!)
                    settingcController.service = tempService//SettingsController(forService: tempService)
                    navigationController?.pushViewController(settingcController, animated: true)
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

    @objc func reloadTableView(){
        tableView.reloadData()
    }

    private func removeAccessory(){
        let alert = UIAlertController(title: "RHKit.common.ios.removeAccessory".localisedString,
                                      message: "RHKit.common.ios.alert.areYoureToRemoveAccessory".localisedString,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.alert.remove".localisedString, style: .destructive) { [unowned self]_ in
            if let accessory = self.service?.accessory{
                RWHomeManager.shared.removeAccessory(accessory, inHome: self.home) { (error) in
                    if let _ = error{
                        self.displayError(error: error!)
                    }
                    RWHomeManager.shared.reloadData()
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: .ItemDeleted, object: nil)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.alert.cancel".localisedString, style: .cancel) { _ in
        })
        present(alert, animated: true)
    }

    private func displayError(error: Error){
        let alert = UIAlertController(title: "RHKit.common.ios.error".localisedString, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.error.ok".localisedString, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
