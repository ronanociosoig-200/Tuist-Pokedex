//
//  Notifier.swift
//  Common
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import Foundation

//sourcery: AutoMockable
public protocol Notifier {
    func dataReceived(errorMessage: String?, on queue: DispatchQueue?)
}
