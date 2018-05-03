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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropTable.delegate = self
        dropTable.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh),for: .valueChanged)
        CD.shared.appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        CD.shared.fetch { (result) in
            self.favourites = result
            self.dropTable.reloadData()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.dropTable.reloadData()
        refreshControl.endRefreshing()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = (favourites[indexPath.row].value(forKey: "name") as! String)
        cell.imageView?.image = UIImage(data: favourites[indexPath.row].value(forKey: "image") as! Data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = favourites[indexPath.row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
        controller.Movie = Movie(dict: [ "title": movie.value(forKey: "name") as AnyObject,
                                         "overview":movie.value(forKey: "overview") as AnyObject,
                                         "genre_ids":movie.value(forKey: "genres") as AnyObject,
                                         "poster_path":"" as AnyObject,
                                         "backdrop_path":movie.value(forKey: "imagebackdrop") as AnyObject,
                                         "vote_average":movie.value(forKey: "vote") as AnyObject,
                                         "release_date":movie.value(forKey: "date") as AnyObject,
                                         "id":movie.value(forKey: "id") as AnyObject])
        navigationController!.pushViewController(controller, animated: true)
    }
}
