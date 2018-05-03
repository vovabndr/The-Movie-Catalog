//
//  FavouriteViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 5/2/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var dropTable: UITableView!
    
    var favourites: [NSManagedObject] = []
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        dropTable.delegate = self
        dropTable.dataSource = self
        refreshControl.addTarget(self, action:#selector(handleRefresh),for: .valueChanged)
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetch()
        dropTable.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.dropTable.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func fetch() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Film")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            favourites = result as! [NSManagedObject]
        } catch let err{
            print(err.localizedDescription)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = (favourites[indexPath.row].value(forKey: "name") as! String)
        cell.imageView?.image = UIImage(data: favourites[indexPath.row].value(forKey: "image") as! Data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let movie = searchMovie[indexPath.row]
//        let controller = storyboard!.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
//        controller.Movie = movie
//
//        navigationController!.pushViewController(controller, animated: true)
    }
    


    
    

}