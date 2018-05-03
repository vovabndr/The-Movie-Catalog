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
//    var movieList = [Movie]()
    

    func getPopular(_ page: Int,handler: @escaping (_ image: [Movie])->()){
        let url = makeUrl(["api_key" :Constants.ApiKey as String as AnyObject,"page":"\(page)" as AnyObject],
                          withPathExtension: "/movie/popular")
        
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                print(error as Any)
                return
            }
        var parsed : [String:AnyObject]?
            do {
                parsed =  try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : AnyObject]
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            let results = parsed!["results"] as? [[String:AnyObject]]
            
            var findedMovie = [Movie]()
//            self.movieList.removeAll()
            for result in results!{
                findedMovie.append(Movie(dict: result))
            }
           
            handler(findedMovie)
        }
        dataTask.resume()
    }
    
    
    func searchMovies(_ searchString: String, completion: @escaping (_ result: [Movie])->() ){
        let url = makeUrl(["api_key" :Constants.ApiKey as String as AnyObject,
                           "query":searchString as String as AnyObject],
                            withPathExtension: "/search/movie")
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
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    struct Genre {
        var name: String
        var id: Int
    }
    var genres = [Genre]()
    func getGenres(_ handler: @escaping ()->()){
        let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=ca39b37eb03cb3bfcfb10578c70e6468&language=en-US")
        let request = URLRequest(url: url!)
        session.dataTask(with: request) { (data, urlresponse, error) in
            guard error == nil else {return}
            var parsedres = [String:AnyObject]()
            do{
                parsedres = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            }catch let error {
                print(error.localizedDescription)
                return
            }
            let results = parsedres["genres"] as! [[String:AnyObject]]
            for result in results{
                self.genres.append(Genre(name: result["name"] as! String, id: result["id"] as! Int))
            }
            handler()
        }.resume()
    }

    
    func getGenre(_ GenreID: Int) -> String{
        switch GenreID {
        case 28:
            return "Action"
        case 12:
            return "Adventure"
        case 16:
            return "Animation"
        case 35:
            return "Comedy"
        case 80:
            return "Crime"
        case 99:
            return "Documentary"
        case 18:
            return "Drama"
        case 10751:
            return "Family"
        case 14:
            return "Fantasy"
        case 36:
            return "History"
        case 27:
            return "Horror"
        case 10402:
            return "Music"
        case 9648:
            return "Mystery"
        case 10749:
            return "Romance"
        case 878:
            return "Science Fiction"
        case 10770:
            return "TV Movie"
        case 53:
            return "Thriller"
        case 10752:
            return "War"
        case 37:
            return "Western"
        default:
            return ""
        }
    }
}
