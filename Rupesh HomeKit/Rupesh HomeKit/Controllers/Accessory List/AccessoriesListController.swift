//
//  AccessoriesListController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///ViewController that displays the list of accessories
class AccessoriesListController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    //MARK:- Data
    ///default cellReuseIdentifier of accessoryCell
    let cellReuseIdentifier = "accessoryCell"

    /// The filtered list of services  app displays.
    var rupeshAccessoryServices :[String: [HMService]]{
        RWHomeManager.shared.rupeshAccessoryServices
    }

    //MARK:- Views
    ///tableView that displays accessories of the app
    let accessoryListTableView: UITableView = {
        let tempTableView = UITableView()
        tempTableView.backgroundColor = AppColor.defaultBackGroundColor
        let tableFooterView = UIView()
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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name.RoomNameEdited, object: nil)

        //set Views
        self.view.backgroundColor = AppColor.defaultBackGroundColor
        setTableView()
        setNavigationBar()
        
        //setTableViewCell
        accessoryListTableView.register(AccessoryTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    //MARK:- SetViews
    //method that sets properties of navigationBar
    private func setNavigationBar(){
        //set NavigationBar Title
        navigationItem.title = "RHKit.common.ios.rupeshAccessories".localisedString

        //set Navigationbar background colors
        self.navigationController?.navigationBar.backgroundColor = AppColor.defaultBackGroundColor
        self.navigationController?.navigationBar.isTranslucent = false

        //set Navigationbar rightBarButton
        let addAccessoryButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccessoryButtonPressed))
        addAccessoryButton.tintColor = AppColor.barButtonItemsBlueColor
        navigationItem.rightBarButtonItem  = addAccessoryButton
    }

    ///Method that sets properties of tableView
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
        // return accessories in ahome
        return rupeshAccessoryServices[RWHomeManager.shared.homesList[section].name]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? AccessoryTableViewCell ?? AccessoryTableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        ///Home of the current section
        let home = RWHomeManager.shared.homesList[indexPath.section]
        ///accessories of the home
        let currentHomeAccessories = rupeshAccessoryServices[home.name]
        ///current accessory the cell needs to display
        if let currentAccessory = currentHomeAccessories?[indexPath.row]{
            //set infobutton to push to accessory details
            cell.infoButtonPressedClosure = {[weak self] in
                self?.navigationController?.pushViewController(AccessoryDetailController(withService: currentAccessory,inHome: home), animated: true)
            }
            //set data for the cell
            cell.setCell(service: currentAccessory)
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        //get number of Homes
        RWHomeManager.shared.homesList.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //get home name of the current cell to set it as a tableView Header
        RWHomeManager.shared.homesList[section].name
    }

    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //set default height of cells
        return Constants.accessoryCellDefaultHeight
    }

    //MARK:- Local Functions

    ///used to reload accessoryListTableView
    @objc private func reloadTableView(){
        self.accessoryListTableView.reloadData()
    }

    ///presents add Accessory Form
    @objc private func addAccessoryButtonPressed(){
        let  addAccessoryController =  UINavigationController(rootViewController: AddAccessoryController())
        self.present( addAccessoryController, animated: true, completion: nil)
    }

}
