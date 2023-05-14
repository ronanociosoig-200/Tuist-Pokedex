//
//  AppController.swift
//  UIComponentsExample
//
//  Created by Ronan on 25/01/2023.
//  Copyright © 2023 eDreams. All rights reserved.
//

import Foundation
import Common

protocol AppControlling {
    func start()
}

class AppController: AppControlling {
    let coordinator = Coordinator()

    func start() {
        let dataProvider = DataProvider()

        if Configuration.uiTesting == true {
            let storage = FileStorage()
            storage.remove(AppData.pokemonFile, from: dataProvider.appData.directory())
        }

        coordinator.start()

        dataProvider.notifier = coordinator as? Notifier
    }
}
