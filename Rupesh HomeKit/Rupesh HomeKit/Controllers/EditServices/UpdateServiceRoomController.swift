//
//  UpdateRoomController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 05/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///controller used to update and add rooms to services and homes respectively
class UpdateRoomController: RWTableViewController {

    //MARK:- data
    ///default identifier for RWHomeKitCell
    let cellIdentifier = "RWHomeKitCell"

    //default service
    ///service for which the room need to be updated
    lazy var service = HMService()
    ///title to be set for viewController
    lazy var key: String = ""
    ///home for ehich the rooms are edited
    var home: HMHome!

    ///provides of rooms in home
    var roomsList: [HMRoom]{
        //get room of entire home
        ///array of rooms in home
        var roomsArray = [home.roomForEntireHome()]
        //add rooms in the home
        roomsArray.append(contentsOf: home.rooms)
        return roomsArray
    }
    
    //MARK:- Initialisers
    
    /// returns an object of UpdateRoomController
    /// used to set rooms for a service
    /// - Parameters:
    ///   - key: title to be set for the viewController
    ///   - service: services for which the room is to be  edited
    ///   - home: home for which rooms are to be edited
    convenience init(withKey key: String,forService service:HMService, inHome home: HMHome){
        self.init()
        self.service = service
        self.key = key
        self.home = home
    }

    //MARK:- ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //set title
        self.title = key
        //set navigation bar buttons
        ///button used to add new rooms
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemPressed))
        addBarButtonItem.tintColor = AppColor.barButtonItemsBlueColor
        navigationItem.rightBarButtonItem = addBarButtonItem
    }

    //MARK:- Private functions
    
    /// method used to display error
    /// - Parameters:
    ///   - error: an optional which displays if error is present
    ///   - message: an optional which displays message as an error
    private func displayError(error: Error?,withStringMessage message: String? = nil){
        //set message for error
        let errorMessage = error != nil ? error?.localizedDescription : message
        let alert = UIAlertController(title: LocalisedStrings.alert_error, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// method to add new room
    ///called when addButton is pressed
    @objc func addBarButtonItemPressed(){
        ///alert that shows textField to set a room name
        let alert = UIAlertController(title: LocalisedStrings.alert_addRoom,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { $0.placeholder = LocalisedStrings.common_name }
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_close, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_create, style: .default) { [unowned self]_ in
            // check if name exists for the home
            if let name = alert.textFields?[0].text {
                //add room
                RWHomeManager.shared.addRoom(inHome: self.home, withName: name) { (room, error) in
                    if let _ = error{
                        self.displayError(error: error)
                    }else{
                        self.tableView.reloadData()
                    }
                }
            }
        })
        //show alert
        present(alert, animated: true)
    }

    //MARK:- TableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //show rooms List
        return roomsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RWHomeKitCell ?? RWHomeKitCell(style: .default, reuseIdentifier: cellIdentifier)
        let currentRoom = roomsList[indexPath.row]
        cell.textLabel?.text = currentRoom.name
        //set accessory type for edit service rooms
        cell.accessoryType = currentRoom.uniqueIdentifier == service.accessory?.room?.uniqueIdentifier ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set cell
        tableView.deselectRow(at: indexPath, animated: true)
        //remove accessory for all cells if present
        tableView.visibleCells.forEach { $0.accessoryType = .none }

        ///room the cell displays
        let currentRoom = roomsList[indexPath.row]
        //get cell
        let cell = tableView.cellForRow(at: indexPath)
        //check if adding service
        if let accessory = service.accessory{
            //move accessory to the selected service
            RWHomeManager.shared.moveAccessory(accessory, inHome: home, toRoom: currentRoom) { [unowned self](error) in
                if let _ = error{
                    self.displayError(error: error)
                }
                //post notification after updating room
                NotificationCenter.default.post(name: Notification.Name.ItemEdited, object: nil)
            }
        }
        //set checkmark to the selectd room
        cell?.accessoryType = .checkmark
    }

    //MARK:- UITableViewDataSource
    //set edit actions to delete cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //set Delete action
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        ///current room of the cell
        let room = roomsList[indexPath.row]
        if (editingStyle == .delete){
            //check whether is add service or the room identifier is not the room of selected cell
            if room.uniqueIdentifier != service.accessory?.room?.uniqueIdentifier{
                ///index of the room to be deleted
                if let firstIndex = self.roomsList.firstIndex(of: room){
                    //remove room
                    RWHomeManager.shared.removeRoom(room, inHome: self.home) { (error) in
                        if let _ = error {
                            self.displayError(error: error)
                        }else{
                            tableView.beginUpdates()
                            let cellIndexPath = IndexPath(row: firstIndex, section: 0)
                            tableView.deleteRows(at: [cellIndexPath], with: .automatic)
                            tableView.endUpdates()
                            //reload RWHomeManager Data after removing rooms
                            RWHomeManager.shared.reloadData()
                        }
                    }
                }
            }else{
                //display error that current toom can't be deleted
                self.displayError(error: nil, withStringMessage: LocalisedStrings.alert_defaultRoomError)
            }
        }
    }

}
