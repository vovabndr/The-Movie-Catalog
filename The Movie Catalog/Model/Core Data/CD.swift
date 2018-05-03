//
//  CD.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 5/3/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import Foundation
import CoreData

class CD{
    static let shared = CD()
    var appDelegate:AppDelegate?
    
    func save(_ Movie:Movie){
        let context = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Film", in: context!)
        let newMovie = NSManagedObject(entity: entity!, insertInto: context)
        
        newMovie.setValue(Movie.name, forKey: "name")
        newMovie.setValue(Movie.overview, forKey: "overview")
        newMovie.setValue(Movie.overview, forKey: "date")
        newMovie.setValue(Movie.vote, forKey: "vote")
        newMovie.setValue(Movie.genres, forKey: "genres")
        newMovie.setValue(Movie.id, forKey: "id")
        if let poster = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w500"+(Movie.imageURL)!)!),
            let backdrop = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w780"+((Movie.backdrop)! as! String))!){
            newMovie.setValue(poster, forKey: "image")
            newMovie.setValue(backdrop, forKey: "imagebackdrop")
        }
        do {
            try context?.save()
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    
    
    func fetch( handle: @escaping (_ result: [NSManagedObject])->()){
        let context = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Film")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            handle(result as! [NSManagedObject])
        } catch let err{
            print(err.localizedDescription)
        }
    }
    
    func checkID(_ id:Int) -> Bool {
        var added = false
        let context = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Film")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request) as! [NSManagedObject]
            for res in result{
                if id == res.value(forKey: "id") as? Int{
                    added = true
                }
            }
        } catch let err{
            print(err.localizedDescription)
        }
        return added
    }

}

