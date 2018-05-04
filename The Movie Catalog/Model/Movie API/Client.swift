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
    
    func GETMovies(_ withPath : String,_ parameters: [String:AnyObject], completion: @escaping (_ result: [Movie] )->()){
        let url = makeUrl(parameters,withPathExtension: withPath)
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                print("Error with your request: \(error!)")
                return
            }
            var parsedResult: [String:AnyObject]?
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            let results = parsedResult!["results"] as? [[String:AnyObject]]
            var searchMovie = [Movie]()
            for result in results!{
                searchMovie.append(Movie(dict: result))
            }
            completion(searchMovie)
        }
        dataTask.resume()
    }
    
    private func makeUrl(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        let apikey = URLQueryItem(name: "api_key", value: Constants.ApiKey)
        components.queryItems?.append(apikey)
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    
    func getGenre()->[String:Int]{
        return ["Action":28,"Adventure":12,"Animation":16,"Comedy":35,
                "Crime":80,"Documentary":99,"Drama":18,"Western":37,
                "Fantasy":14,"History":36,"Horror":27,"Thriller":53,
                "Science Fiction":878,"Mystery":9648,"Music":10402,
                "Romance":10749,"TV Movie":10770,"Family":10751,"War":10752]
    }
}
