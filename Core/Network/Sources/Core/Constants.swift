//
//  Constants.swift
//  NetworkKit
//
//  Created by Ronan on 09/05/2019.
//  Copyright © 2019 Sonomos. All rights reserved.
//

import Foundation

// swiftlint:disable nesting identifier_name

struct Constants {
    enum Network {
        static let transport = "https://"
        static let baseDomain = "pokeapi.co"
        static let baseAPI = "/api/v2/"
        static let searchPath = "pokemon"
    }
    
    enum Translations {
        struct Error {
            static let jsonDecodingError = "Error: JSON decoding error."
            static let noDataError = "Error: No data received."
            static let noResultsFound = "No results were found for your search."
            static let statusCode404 = "404"
            static let notFound = "Error 401 Pokemon not found"
        }
    }
}
