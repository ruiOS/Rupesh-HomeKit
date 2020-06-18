//
//  AddAccessoryController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

///Controller used to add accessories
class AddAccessoryController: RWTableViewController {

    //MARK:- Data
    ///default cell identifier for HomeListCell
    let cellIdentifier = "HomeListCell"

    ///homesList the homeManagerContains
    var homesList:[HMHome]{
        RWHomeManager.shared.homesList
    }

    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //add navigation bar items

        //set navigation bar title
        self.title = LocalisedStrings.title_homesList

        //add navigation bar buttons
        ///button to add homes
        let addHomeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        addHomeButton.tintColor = AppColor.barButtonItemsBlueColor
        navigationItem.rightBarButtonItem = addHomeButton

        //set notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .RoomNameEdited, object: nil)

    }

    //MARK:- Private funtions
    ///Method used to reload tableView
    @objc private func reloadTableView(){
        tableView.reloadData()
    }

    /// Method used to display error
    /// - Parameter error: error to be displayed
    private func displayError(error: Error?){
        let alert = UIAlertController(title: LocalisedStrings.alert_error, message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    ///method called when addButton is pressed
    ///used to add new homes
    @objc func addButtonPressed(){
        //show alert to add home
        ///alert used to add ahome
        let alert = UIAlertController(title: LocalisedStrings.alert_addHome,
                                      message: nil,
                                      preferredStyle: .alert)
        //add textField to alert
        alert.addTextField { $0.placeholder = LocalisedStrings.common_name }
        //set alert actions
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_close, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: LocalisedStrings.alert_create, style: .default) { [unowned self]_ in
            // check if name exists for the home
            if let name = alert.textFields?[0].text {
                //add home
                RWHomeManager.shared.addHome(withName: name) {[unowned self] (home, error) in
                    if let _ = error{
                        alert.dismiss(animated: true) {[unowned self] in
                            self.displayError(error: error)
                        }
                    }else if let _ = home{
                        //add home to RWHomeManager's homeslist
                        RWHomeManager.shared.homesList.append(home!)
                    }
                }

            }
        })
        //present alert form to add home
        present(alert, animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //set edit actions to delete cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //set delete action
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let home = homesList[indexPath.row]
        if (editingStyle == .delete){
            //remove home
            RWHomeManager.shared.removeHome(home) { [unowned self](error) in
                if let _ = error{
                    self.displayError(error: error)
                }else{
                    //remove deleted home's tableView
                    tableView.beginUpdates()
                    if let firstIndex = self.homesList.firstIndex(of: home){
                        let cellIndexPath = IndexPath(row: firstIndex, section: 0)
                        //removed deleted home from homesList
                        RWHomeManager.shared.homesList.removeAll { $0.uniqueIdentifier == home.uniqueIdentifier }
                        tableView.deleteRows(at: [cellIndexPath], with: .automatic)
                        tableView.endUpdates()
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get all homes count
        return homesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RWHomeKitCell ?? RWHomeKitCell(style: .default, reuseIdentifier: cellIdentifier)
        //set home name to cell
        cell.textLabel?.text = homesList[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //set cell default height
        return Constants.defaultCellHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //push to set room for the accessories
        RWHomeManager.shared.addAccessories(toHome: self.homesList[indexPath.row]) { [weak self](error) in
            if let error = error{
                self?.displayError(error: error)
            }else{
                self?.navigationController?.dismiss(animated: true, completion: {
                    //post notification after adding service
                    RWHomeManager.shared.reloadData()
                    NotificationCenter.default.post(name: Notification.Name.ItemEdited, object: nil)
                })
            }
        }
    }
}
