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
            if let imagedata = Movie?.backdropData as? Data{
                imageView.image = UIImage(data: imagedata)
            }else{
                imageView.addImageFromURL(urlMovie: Movie?.backdrop)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.title = Movie?.name
        setButton()
    }
    //MARK: - Button
    @IBAction func AddButton(_ sender: UIButton) {
        if !CD.shared.checkID((self.Movie?.id!)!){
            CD.shared.save(self.Movie!)
            setButton()
        }else{
            let alert = UIAlertController(title: "Remove \"\(String(describing: (Movie?.name!)!))\" from favourites?",message: nil,preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Remove", style: .default){_ in
                CD.shared.fetch(handle: { (res) in
                    CD.shared.deleteByID(filmID: (self.Movie?.id!)!, manageObj: res)
                    self.setButton()
                })
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setButton(){
        if CD.shared.checkID((self.Movie?.id!)!){
            favouriteButton.setTitleColor(.red, for: .normal)
            favouriteButton.setTitle("Remove from favourite".capitalized, for: .normal)
        }else{
            favouriteButton.setTitleColor(.black, for: .normal)
            favouriteButton.setTitle("Add to favourite".capitalized, for: .normal)
        }
        
    }
}
