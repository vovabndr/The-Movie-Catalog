//
//  Client.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/26/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import Foundation

class Client{
    
    //MARK: - Shared instance
    static let shared = Client()
    
    
    var session = URLSession.shared
    
    var movieList = [Movie]()

//
    var i = 1
//
    func getPopular(handler: @escaping (_ image: [Movie])->()){
    var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/popular?page=\(i)&language=en&api_key=ca39b37eb03cb3bfcfb10578c70e6468")!)
        request.httpMethod = "GET"
        i = i + 1
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            if (error != nil) {
                print(error as Any)
            } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse as Any)
            }
            
            var parsed : [String:AnyObject]?
            do {
                parsed =  try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : AnyObject]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            let results = parsed!["results"] as? [[String:AnyObject]]
//            self.movieList.removeAll()
            for result in results!{
                self.movieList.append(Movie(dict: result))
            }
           
            handler(self.movieList)
        }
        dataTask.resume()
    }

    
    
    
}