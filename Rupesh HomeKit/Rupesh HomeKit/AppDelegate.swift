//
//  AppDelegate.swift
//  Rupesh HomeKit
//
//  Created by rupesh on 04/06/20.
//  Copyright © 2020 rupesh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    ///Shared window accross the app
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //set DarkMode for iOS13 AndAbove
        if #available(iOS 13, *) {
            AppColor.setColorsForiOS13AndAbove()
        }

        //Set MainViewController as window's rootViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVc = AccessoriesListController()
        window?.rootViewController = UINavigationController(rootViewController: mainVc)
        window?.makeKeyAndVisible()
        return true
    }

}

