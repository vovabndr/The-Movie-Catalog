//
//  DetailTableViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 5/1/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController {

    var Movie: Movie?

    @IBOutlet weak var imageView: UIImageView!
//        {
//        didSet{
//            imageView.addImageFromURL(urlMovie: Movie?.backdrop)
//        }
//    }
    @IBOutlet weak var movieName: UILabel!{
        didSet{
            movieName.text = Movie?.name
        }
    }
    @IBOutlet weak var overview: UITextView!{
        didSet{
            overview.text = Movie?.overview
        }
    }
    @IBOutlet weak var ratingView: RatingView!{
        didSet{
            ratingView.set(vote: (Movie?.vote)!)
        }
    }
    @IBOutlet weak var releaseDate: UILabel!{
        didSet{
            releaseDate.text = Movie?.release
        }
    }
    @IBOutlet weak var genre: UILabel!{
        didSet{
            genre.text?.removeAll()
            for genr in (Movie?.genres)!{
                genre.text?.append( " " + Client.shared.getGenre(genr) + ",")
            }
            genre.text =  String((genre.text?.dropLast())!)
        }
    }
    @IBOutlet weak var favouriteButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.title = Movie?.name
        
    }
    
    
    @IBAction func AddButton(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Film", in: context)
        let newMovie = NSManagedObject(entity: entity!, insertInto: context)

        newMovie.setValue(self.Movie?.name, forKey: "name")
        newMovie.setValue(self.Movie?.overview, forKey: "overview")
        newMovie.setValue(self.Movie?.overview, forKey: "date")
        newMovie.setValue(self.Movie?.vote, forKey: "vote")
        newMovie.setValue(self.Movie?.genres, forKey: "genres")
        
        if let poster = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w780"+(self.Movie?.imageURL)!)!),
        let backdrop = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w780"+(self.Movie?.backdrop)!)!){
            newMovie.setValue(poster, forKey: "image")
            newMovie.setValue(backdrop, forKey: "imagebackdrop")
            }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    

    
    }



    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


