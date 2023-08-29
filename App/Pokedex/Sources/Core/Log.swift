//
//  Log.swift
//  PokedexCommon
//
//  Created by Ronan O Ciosig on 5/6/21.
//  Copyright © 2021 Sonomos.com. All rights reserved.
//

import Foundation
import os.log

let subsystem = "com.sonomos.pokedex"

public struct Log {
    public static var general = OSLog(subsystem: subsystem, category: "general")
    public static var network = OSLog(subsystem: subsystem, category: "network")
    public static var data = OSLog(subsystem: subsystem, category: "data")
}
