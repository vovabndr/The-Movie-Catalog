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
    var overview:String?
    var vote:Double?
    var genres:[Int]?
    var backdrop:String?
    var release: String?
    
    init(dict: [String:AnyObject]) {
        self.name = (dict["title"] as! String)
        self.imageURL = (dict["poster_path"] as! String)
        self.overview = (dict["overview"] as! String)
        self.genres = (dict["genre_ids"] as! [Int])
        self.backdrop = (dict["backdrop_path"] as! String) 
        self.vote = (dict["vote_average"] as! Double)
        self.release = (dict["release_date"] as! String)
    }
    
}