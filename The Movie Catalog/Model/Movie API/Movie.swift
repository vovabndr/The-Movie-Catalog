//
//  Movie.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/27/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import Foundation

struct Movie {
    
    var name: String?
    var imageURL: String?
    
    init(name: String,image:String) {
        self.name = name
        self.imageURL = image
    }
    
}
