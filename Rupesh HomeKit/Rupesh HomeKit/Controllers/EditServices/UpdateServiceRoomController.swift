//
//  UpdateServiceRoomController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 05/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

class UpdateServiceRoomController: RWTableViewController {

    //MARK:- data
    let cellIdentifier = "CellIdentifier"

    var service = HMService()
    var key: String = ""
    var home: HMHome!

    var roomsList: [HMRoom]{
        var roomsArray = [home.roomForEntireHome()]
        roomsArray.append(contentsOf: home.rooms)
        return roomsArray
    }
    
    //MARK:- Initialisers

    convenience init(withKey key: String,forService service:HMService, inHome home: HMHome){
        self.init()
        self.service = service
        self.key = key
        self.home = home
    }

    //MARK:- ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = key

        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemPressed))
        addBarButtonItem.tintColor = AppColor.barButtonItemsBlueColor
        navigationItem.rightBarButtonItem = addBarButtonItem
    }

    //MARK:- Private functions
    private func displayError(error: Error?,withStringMessage message: String? = nil){
        let message = error != nil ? error?.localizedDescription : message
        let alert = UIAlertController(title: "RHKit.common.ios.error".localisedString, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.error.ok".localisedString, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func addBarButtonItemPressed(){
        let alert = UIAlertController(title: "RHKit.common.ios.addRoom".localisedString,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "RHKit.common.ios.name".localisedString }
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.close".localisedString, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.create".localisedString, style: .default) { [unowned self]_ in
            if let name = alert.textFields?[0].text {
                RWHomeManager.shared.addRoom(inHome: self.home, withName: name) { (room, error) in
                    if let _ = error{
                        self.displayError(error: error)
                    }else{
                        NotificationCenter.default.post(name: Notification.Name.HomeNameEdited, object: nil)
                        self.tableView.reloadData()
                    }
                }
            }
        })
        present(alert, animated: true)
    }

    //MARK:- TableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RWHomeKitCell ?? RWHomeKitCell(style: .default, reuseIdentifier: cellIdentifier)
        let currentRoom = roomsList[indexPath.row]
        cell.textLabel?.text = currentRoom.name
        cell.accessoryType = currentRoom.uniqueIdentifier == service.accessory?.room?.uniqueIdentifier ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.visibleCells.forEach { $0.accessoryType = .none }
        let cell = tableView.cellForRow(at: indexPath)
        if let accessory = service.accessory{
            RWHomeManager.shared.moveAccessory(accessory, inHome: home, toRoom: roomsList[indexPath.row]) { [unowned self](error) in
                if let _ = error{
                    self.displayError(error: error)
                }
                NotificationCenter.default.post(name: Notification.Name.ItemEdited, object: nil)
            }
        }
        cell?.accessoryType = .checkmark
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let room = roomsList[indexPath.row]
        if (editingStyle == .delete){
            if room.uniqueIdentifier != service.accessory?.room?.uniqueIdentifier{
                if let firstIndex = self.roomsList.firstIndex(of: room){
                    RWHomeManager.shared.removeRoom(room, inHome: self.home) { (error) in
                        if let _ = error {
                            self.displayError(error: error)
                        }
                        else{
                            tableView.beginUpdates()
                            let cellIndexPath = IndexPath(row: firstIndex, section: 0)
                            tableView.deleteRows(at: [cellIndexPath], with: .automatic)
                            tableView.endUpdates()
                        }
                    }
                    
                }
            }else{
                self.displayError(error: nil, withStringMessage: "RHKit.common.ios.error.defaultRoomError".localisedString)
            }
        }
    }

}
