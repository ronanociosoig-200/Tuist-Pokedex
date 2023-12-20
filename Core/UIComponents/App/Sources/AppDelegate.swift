//
//  AppDelegate.swift
//  UIComponentsExample
//
//  Created by Ronan on 25/01/2023.
//  Copyright © 2023 eDreams. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {

    private let appController = AppController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appController.start()
        return true
    }
}
