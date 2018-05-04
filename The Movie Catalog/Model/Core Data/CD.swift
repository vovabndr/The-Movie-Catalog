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
        newMovie.setValue(Movie.name,forKey: "name")
        newMovie.setValue(Movie.overview,forKey: "overview")
        newMovie.setValue(Movie.release,forKey: "date")
        newMovie.setValue(Movie.vote,forKey: "vote")
        newMovie.setValue(Movie.genres,forKey: "genres")
        newMovie.setValue(Movie.id,forKey: "id")
        newMovie.setValue(Movie.imageURL!,forKey: "imageURL")

        if Movie.backdrop != nil {
            newMovie.setValue(Movie.backdrop!,forKey: "backdropURL")
        }
        if let poster = try? Data(contentsOf: URL(string:"https://image.tmdb.org/t/p/w500"+(Movie.imageURL)!)!){
            newMovie.setValue(poster, forKey: "image")
        }
        if Movie.backdropData != nil{
            newMovie.setValue(Movie.backdropData, forKey: "imagebackdrop")
        }else if Movie.backdrop != nil, let backdrop = try? Data(contentsOf: URL(string:"https://image.tmdb.org/t/p/w780" + Movie.backdrop!)!) {
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
        } catch let error{
            print(error.localizedDescription)
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
        } catch let error{
            print(error.localizedDescription)
        }
        return added
    }
    
    func delete( index:Int, manageObj:[NSManagedObject]){
        let context = appDelegate?.persistentContainer.viewContext
        context?.delete(manageObj[index])
        do {
            try context?.save()
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    func deleteByID(filmID: Int, manageObj:[NSManagedObject]){
        let context = appDelegate?.persistentContainer.viewContext
        for i in 0...manageObj.count - 1{
            if manageObj[i].value(forKey: "id") as? Int == filmID{
                context?.delete(manageObj[i])
            }
        }
            do {
                try context?.save()
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }



