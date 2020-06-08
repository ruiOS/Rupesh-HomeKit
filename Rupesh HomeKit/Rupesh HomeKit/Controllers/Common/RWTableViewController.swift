//
//  RWTableViewController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 05/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

///Default TableView Controller for the app, that consists of all the properties needed for the tableViewcontrollers of the app
class RWTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //View Properties
        self.view.backgroundColor = AppColor.defaultBackGroundColor

        //TableView Properties
        self.tableView.backgroundColor = AppColor.defaultBackGroundColor
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }

}
