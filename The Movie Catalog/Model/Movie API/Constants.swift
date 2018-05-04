//
//  File.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/26/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import Foundation

struct Constants {
    static let ApiKey = Bundle.main.infoDictionary!["API Key"] as! String
    static let ApiScheme = "https"
    static let ApiHost = "api.themoviedb.org"
    static let ApiPath = "/3"
}
