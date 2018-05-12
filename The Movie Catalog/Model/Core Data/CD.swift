//
//  CD.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 5/3/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import Foundation
import CoreData

class DataManage {
    static let shared = DataManage()
    weak var appDelegate: AppDelegate?

    func save(_ movie: Movie) {
        let context = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Film", in: context!)
        let newMovie = NSManagedObject(entity: entity!, insertInto: context)

        newMovie.setValue(movie.name, forKey: "name")
        newMovie.setValue(movie.overview, forKey: "overview")
        newMovie.setValue(movie.release, forKey: "date")
        newMovie.setValue(movie.vote, forKey: "vote")
        newMovie.setValue(movie.genres, forKey: "genres")
        newMovie.setValue(movie.id, forKey: "id")
        newMovie.setValue(movie.imageURL, forKey: "imageURL")

        if movie.backdrop != nil {
            newMovie.setValue(movie.backdrop!, forKey: "backdropURL")
        }
        if let poster = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w500"+(movie.imageURL)!)!) {
            newMovie.setValue(poster, forKey: "image")
        }
        if let poster = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w500"+(movie.imageURL)!)!) {
            newMovie.setValue(poster, forKey: "image")
        }
        if movie.backdropData != nil {
            newMovie.setValue(movie.backdropData, forKey: "imagebackdrop")
        } else if movie.backdrop != nil,
            let backdrop = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w780" + movie.backdrop!)!) {
                newMovie.setValue(backdrop, forKey: "imagebackdrop")
        }

        do {
            try context?.save()
        } catch let error {
            print(error.localizedDescription)
        }

    }

    func fetch( handle: @escaping (_ result: [NSManagedObject]) -> Void) {
        let context = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Film")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context?.fetch(request) as? [NSManagedObject] {
            handle(result)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func checkID(_ movieid: Int) -> Bool {
        var added = false
        let context = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Film")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context?.fetch(request) as? [NSManagedObject] {
            for res in result {
                if movieid == res.value(forKey: "id") as? Int {
                    added = true
                }
            }
        }
        } catch let error {
            print(error.localizedDescription)
        }
        return added
    }

    func delete( index: Int, manageObj: [NSManagedObject]) {
        let context = appDelegate?.persistentContainer.viewContext
        context?.delete(manageObj[index])
        do {
            try context?.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteByID(filmID: Int, manageObj: [NSManagedObject]) {
        let context = appDelegate?.persistentContainer.viewContext
        for obj in 0...manageObj.count - 1 {
            if manageObj[obj].value(forKey: "id") as? Int == filmID {
                context?.delete(manageObj[obj])
            }
        }
            do {
                try context?.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
