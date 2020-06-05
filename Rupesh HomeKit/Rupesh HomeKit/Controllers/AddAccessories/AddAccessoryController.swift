//
//  AddAccessoryController.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit
import HomeKit

class AddAccessoryController: RWTableViewController {

    let cellIdentifier = "HomeListCell"
    
    var homesList:[HMHome]{
        RWHomeManager.shared.homesList
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let addHomeButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        addHomeButton.tintColor = AppColor.barButtonItemsBlueColor
        navigationItem.rightBarButtonItem = addHomeButton

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .HomeNameEdited, object: nil)
        self.title = "RHKit.common.ios.homesList".localisedString

    }

    //MARK:- Private funtions
    @objc private func reloadTableView(){
        tableView.reloadData()
    }

    private func displayError(error: Error?){
        let alert = UIAlertController(title: "RHKit.common.ios.error".localisedString, message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.error.ok".localisedString, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func addButtonPressed(){
        let alert = UIAlertController(title: "RHKit.common.ios.addAHome".localisedString,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "RHKit.common.ios.name".localisedString }
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.close".localisedString, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "RHKit.common.ios.create".localisedString, style: .default) { [unowned self]_ in
            if let name = alert.textFields?[0].text {
                RWHomeManager.shared.addHome(withName: name) {[unowned self] (home, error) in
                    if let _ = error{
                        alert.dismiss(animated: true) {[unowned self] in
                            self.displayError(error: error)
                        }
                    }else if let _ = home{
                        RWHomeManager.shared.homesList.append(home!)
                    }
                }

            }
        })
        present(alert, animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let home = homesList[indexPath.row]
        if (editingStyle == .delete){
            RWHomeManager.shared.removeHome(home) { [unowned self](error) in
                if let _ = error{
                    self.displayError(error: error)
                }else{
                    tableView.beginUpdates()
                    if let firstIndex = self.homesList.firstIndex(of: home){
                        let cellIndexPath = IndexPath(row: firstIndex, section: 0)
                        RWHomeManager.shared.homesList.removeAll { $0.uniqueIdentifier == home.uniqueIdentifier }
                        tableView.deleteRows(at: [cellIndexPath], with: .automatic)
                        tableView.endUpdates()
                    }
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RWHomeKitCell ?? RWHomeKitCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = homesList[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.defaultCellHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RWHomeManager.shared.addAccessories(toHome: homesList[indexPath.row],completionHandler:{ error in
            if let error = error {
                print(error)
            } else {
                RWHomeManager.shared.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
