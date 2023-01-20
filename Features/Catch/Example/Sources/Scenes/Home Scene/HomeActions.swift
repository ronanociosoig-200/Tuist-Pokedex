//
//  HomeViewActions.swift
//  Catch
//
//  Created by Ronan O Ciosig on 01/07/21.
//  Copyright © 2021 Sonomos.com. All rights reserved.
//

import Foundation
import Common

protocol HomeActions {
    func catchButtonAction()
    func catchFixedbuttonAction()
    func catchErrorButtonAction()
}

extension Actions: HomeActions {
    func catchButtonAction() {
        coordinator.showCatchScene()
    }
    
    func catchFixedbuttonAction() {
        coordinator.showCatchScene()
    }
    
    func catchErrorButtonAction() {
        coordinator.showCatchScene()
    }
}
