//
//  RWHomeManager.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import Foundation
import HomeKit

///DataModel that manages all the services accross the app
class RWHomeManager:NSObject,HMHomeManagerDelegate {

    ///A static instance of RWHomeManager
    static let shared = RWHomeManager()

    /// The home whose accessories the app currently displays.
    var homesList: [HMHome] = [HMHome]() {
        didSet {
            reloadData()
            NotificationCenter.default.post(name: Notification.Name.HomeNameEdited, object: nil)
        }
    }

    ///default HWhomeManager of the app to manage collection of homes
    let homeManager = HMHomeManager()

    ///accessoryServices Stored as a dictionary.
    ///key is passed as a string which returns values as an aeeay of services
    var rupeshAccessoryServices: [String: [HMService]] = [String:[HMService]]()

    private override init(){
        super.init()
        ///assign HomeManagerDelegate to self
        homeManager.delegate = self
    }

    
    /// Used to add home to the manager
    /// - Parameters:
    ///   - name: name of the home to be added
    ///   - completion: Completion block that is executed after home is added
    func addHome(withName name: String,completion:@escaping ((HMHome?, Error?)->Void)){
        homeManager.addHome(withName: name, completionHandler: completion)
    }
    
    /// Used to add accessories to the home
    /// - Parameters:
    ///   - home: name of the accessory to be added
    ///   - completion: Completion block that is executed after home is added
    func addAccessories(toHome home: HMHome,completionHandler completion:@escaping ((Error?)->Void)){
        home.addAndSetupAccessories(completionHandler: completion)
    }
    
    /// - Parameters:
    ///   - home: home to be removed
    /// - completion: Completion block that is executed after home is added
    func removeHome(_ home: HMHome,completionHandler completion: @escaping ((Error?)->Void) ){
        homeManager.removeHome(home, completionHandler: completion)
    }

    /// Resfreshes the list to load services
    @objc func reloadData() {
        rupeshAccessoryServices.removeAll()
        for aHome in homesList{
            for accessory in aHome.accessories.filter({ $0.manufacturer == "Kilgo Devices, Inc." }) {
                var items: [HMService] = [HMService]()
                for service in accessory.services.filter({ $0.isUserInteractive }) {
                    items.append(service)
                }
                rupeshAccessoryServices[aHome.name] = items
            }
        }
        NotificationCenter.default.post(name: Notification.Name.ItemEdited, object: nil)
    }

    //MARK:-HomeManager Delegate
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        setOrAddHome(manager: manager)
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        setOrAddHome(manager: manager)
    }

    /// Sets the home to either the primary home, or the first home, or a home that the user creates.
    /// - Parameter manager: manager that is passed ro set or add home
    func setOrAddHome(manager: HMHomeManager) {
        homesList = manager.homes
    }
    
    /// Used to rename a service
    /// - Parameters:
    ///   - service: service to which the name needed to be edited
    ///   - name: new name to be saved
    func updateServiceName(forService service:HMService,toName name: String){
        service.updateName(name, completionHandler: {[unowned self] error in
            if let _ = error{
                print(error as Any)
            }
            self.reloadData()
        })
    }

    
    /// used to move acessory from one room to another room in home
    /// - Parameters:
    ///   - accessory: accessory that needs to be moved
    ///   - home: home in which the accessory is present
    ///   - room: room to whuch the accessory need to be moved
    ///   - completion: Completion block that is executed after home is added
    func moveAccessory(_ accessory:HMAccessory, inHome home: HMHome,toRoom room: HMRoom, completion:@escaping ((Error?) -> Void)){
        home.assignAccessory(accessory, to: room, completionHandler: completion)
    }
    
    /// used to add room in home
    /// - Parameters:
    ///   - home: home in which the room need to be added
    ///   - name: name of the room to be added
    ///   - completion: Completion block that is executed after home is added
    func addRoom(inHome home: HMHome, withName name: String,completionHandler completion:@escaping ((HMRoom?,Error?)->Void)){
        home.addRoom(withName: name, completionHandler: completion)
    }
    
    /// used to remove room
    /// - Parameters:
    ///   - room: room which need to be removed
    ///   - home: home in which the rrom need to added
    ///   - completion: Completion block that is executed after home is added
    func removeRoom(_ room: HMRoom, inHome home: HMHome,completionHandler completion: @escaping ((Error?)->Void)){
        home.removeRoom(room, completionHandler: completion)
    }
    
    /// used to remove accessoryaccessory
    /// - Parameters:
    ///   - accessory: accessory needed to be removed
    ///   - home: home from which the accessory need to be removed
    ///   - completion: Completion block that is executed after home is added
    func removeAccessory(_ accessory: HMAccessory,inHome home: HMHome, completionHandler completion: @escaping ((Error?)->Void)){
        home.removeAccessory(accessory, completionHandler: completion)
    }

}
