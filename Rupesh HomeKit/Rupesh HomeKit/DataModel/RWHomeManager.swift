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

    //MARK:- Data
    /// The home whose accessories the app currently displays.
    var homesList: [HMHome] = [HMHome]() {
        didSet {
            reloadData()
            NotificationCenter.default.post(name: Notification.Name.RoomNameEdited, object: nil)
        }
    }

    ///accessoryServices Stored as a dictionary.
    ///key is passed as a string which returns values as an aeeay of services
    var rupeshAccessoryServices: [String: [HMService]] = [String:[HMService]]()

    ///default HWhomeManager of the app to manage collection of homes
    let homeManager = HMHomeManager()

    //MARK:- Set Singleton
    ///A static singleton instance of RWHomeManager
    static let shared = RWHomeManager()

    private override init(){
        super.init()
        ///assign HomeManagerDelegate to self
        homeManager.delegate = self
    }

    //MARK:- Internal functions
    /// Used to add home to the manager
    /// - Parameters:
    ///   - name: name of the home to be added
    ///   - completion: Completion block that is executed after home is added
    func addHome(withName name: String,completion:@escaping ((HMHome?, Error?)->Void)){
        homeManager.addHome(withName: name, completionHandler: completion)
    }
    
    /// Used to add accessories to the home
    /// - Parameters:
    ///   - home: home of the accessory to be added
    ///   - completion: Completion block that is executed after accessory is added
    func addAccessories(toHome home: HMHome,completionHandler completion:@escaping ((Error?)->Void)){
        home.addAndSetupAccessories(completionHandler: completion)
    }

    
    /// method used to add accessory in the s=desired room of home
    /// - Parameters:
    ///   - room: room of the accessory to be added
    ///   - home: home of the accessory to be added
    ///   - errorBlock: error block to be executed to handle errors
    ///   - completionHandler: Completion block that is executed after home is added
    func addAccessory(inRoom room: HMRoom,ofHome home: HMHome, errorBlock: @escaping (((Error?)->Void)), completionHandler: @escaping (()->Void)){
        //check old accessories
        let oldAccessories = home.accessories
        //add new accessory
        self.addAccessories(toHome: home,completionHandler:{ error in
            if let error = error, error._code != 23 {
                errorBlock(error)
            } else {
                //reload data after adding accessory
                self.reloadData()
                //get newly of all added accessory by removing old accessory from all accessories
                let addedAccessories = home.accessories.filter { !oldAccessories.contains($0) }
                //get added accessories
                for anAccessory in addedAccessories{
                    //move added accessory to new room
                    RWHomeManager.shared.moveAccessory(anAccessory, inHome: home, toRoom: room) { (error) in
                        if error?._code != 23{
                            errorBlock(error)
                        }
                    }
                    //call completion block
                    completionHandler()
                }
            }
        })
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
        //check every home
        for aHome in homesList{
            //check every accessory in home
            for accessory in aHome.accessories {
                var items: [HMService] = [HMService]()
                //check whether the service is compatiable
                for service in accessory.services.filter({ $0.serviceType != HMServiceTypeAccessoryInformation }) {
                    //add compatiable service to items
                    items.append(service)
                }
                //add services
                if rupeshAccessoryServices[aHome.name] == nil || rupeshAccessoryServices[aHome.name]?.count == 0{
                    rupeshAccessoryServices[aHome.name] = items
                }else{
                    rupeshAccessoryServices[aHome.name]?.append(contentsOf: items)
                }
            }
        }
        //post notification
        NotificationCenter.default.post(name: Notification.Name.ItemEdited, object: nil)
    }

    //MARK:-HomeManager Delegate
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        //set home
        setOrAddHome(manager: manager)
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        //set home
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
