//
//  AccessoriesListController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///ViewController that displays accessories List
class AccessoriesListController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    //MARK:- Data
    ///default cellReuseIdentifier of accessoryCell
    let cellReuseIdentifier = "accessoryCell"

    /// The filtered list of services that the app displays.
    var rupeshAccessoryServices :[String: [HMService]]{
        RWHomeManager.shared.rupeshAccessoryServices
    }

    //MARK:- Views
    let accessoryListTableView: UITableView = {
        let tempTableView = UITableView()
        tempTableView.backgroundColor = AppColor.defaultBackGroundColor
        let tableFooterView = UIView()
        tableFooterView.backgroundColor = AppColor.defaultBackGroundColor
        tempTableView.tableFooterView = tableFooterView
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        return tempTableView
    }()

    //MARK:- ViewLife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //enable Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name.ItemDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name.ItemEdited, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name.HomeNameEdited, object: nil)

        //set Viewa
        self.view.backgroundColor = AppColor.defaultBackGroundColor
        setTableView()
        setNavigationBar()
        
        //setTableViewCell
        accessoryListTableView.register(AccessoryTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    //MARK:- SetViews
    private func setNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = AppColor.defaultBackGroundColor
        self.navigationController?.navigationBar.isTranslucent = false

        let addAccessoryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccessoryButtonPressed))
        addAccessoryButton.tintColor = AppColor.barButtonItemsBlueColor
        navigationItem.rightBarButtonItem  = addAccessoryButton

        navigationItem.title = "RHKit.common.ios.rupeshAccessories".localisedString
    }

    private func setTableView(){
        accessoryListTableView.dataSource = self
        accessoryListTableView.delegate = self
        accessoryListTableView.separatorStyle = .none
        self.view.addSubview(accessoryListTableView)
        accessoryListTableView.topAnchor.constraint(equalTo: self.view.safeTopAnchor).isActive = true
        accessoryListTableView.bottomAnchor.constraint(equalTo: self.view.safeBottomAnchor).isActive = true
        accessoryListTableView.leadingAnchor.constraint(equalTo: self.view.safeLeadingAnchor).isActive = true
        accessoryListTableView.trailingAnchor.constraint(equalTo: self.view.safeTrailingAnchor).isActive = true
    }

    //MARK:- UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get count of accessories in a home
        rupeshAccessoryServices[RWHomeManager.shared.homesList[section].name]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? AccessoryTableViewCell ?? AccessoryTableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        let home = RWHomeManager.shared.homesList[indexPath.section]
        let currentHomeAccessories = rupeshAccessoryServices[home.name]
        if let currentAccessory = currentHomeAccessories?[indexPath.row]{
            cell.infoButtonPressedClosure = {[weak self] in
                self?.navigationController?.pushViewController(AccessoryDetailController(withService: currentAccessory,inHome: home), animated: true)
            }
            cell.setCell(service: currentAccessory)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        //get List of Homes and set each home as a header
        RWHomeManager.shared.homesList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        RWHomeManager.shared.homesList[section].name
    }

    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.accessoryCellDefaultHeight
    }

    //MARK:- Local Functions

    @objc func reloadTableView(){
        self.accessoryListTableView.reloadData()
    }

    @objc func addAccessoryButtonPressed(){
        let  addAccessoryController =  UINavigationController(rootViewController: AddAccessoryController())
        self.present( addAccessoryController, animated: true, completion: nil)
    }

}
