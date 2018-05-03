//
//  DetailTableViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 5/1/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var Movie: Movie?
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
        {
        didSet{
            if Movie?.backdrop is String{
            imageView.addImageFromURL(urlMovie: (Movie?.backdrop as! String))
            }else if Movie?.backdrop is Data{
                imageView.image = UIImage(data: (Movie?.backdrop)! as! Data)
            }
        }
    }
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
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        CD.shared.appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.title = Movie?.name
        setButton()
    }
    @IBAction func AddButton(_ sender: UIButton) {
        if !CD.shared.checkID((self.Movie?.id!)!){
            CD.shared.save(self.Movie!)
            setButton()
        }
    }
    
    func setButton(){
        if CD.shared.checkID((self.Movie?.id!)!){
            favouriteButton.isEnabled = false
            favouriteButton.setTitle("remove from favourite", for: .normal)
        }else{
            
        }
        
    }
}
