//
//  DetailTableViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 5/1/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var movie: Movie?
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            if let imagedata = movie?.backdropData as? Data {
                imageView.image = UIImage(data: imagedata)
            } else {
                imageView.addImageFromURL(urlMovie: movie?.backdrop)
            }

        }
    }
    @IBOutlet weak var movieName: UILabel! {
        didSet {
            movieName.text = movie?.name
        }
    }
    @IBOutlet weak var overview: UITextView! {
        didSet {
            overview.text = movie?.overview
        }
    }
    @IBOutlet weak var ratingView: RatingView! {
        didSet {
            ratingView.set(vote: (movie?.vote)!)
        }
    }
    @IBOutlet weak var releaseDate: UILabel! {
        didSet {
            releaseDate.text = movie?.release
        }
    }
    @IBOutlet weak var genre: UILabel! {
        didSet {
            genre.text?.removeAll()
            for (key, value) in Client.shared.getGenre() {
                for genr in (movie?.genres)! where genr==value {
                        genre.text?.append(" " + key + ",")
                }
            }
            genre.text =  String((genre.text?.dropLast())!)
        }
    }
    @IBOutlet weak var favouriteButton: UIButton!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.title = movie?.name
        setButton()
    }
    // MARK: - Button
    @IBAction func addButton(_ sender: UIButton) {
        if !DataManage.shared.checkID((self.movie?.id)!) {
            DataManage.shared.save( self.movie!)
            setButton()
        } else {
            guard let name = movie?.name else { return  }
            let alert = UIAlertController(title: "Remove \"\(name)\" from favorites?",
                message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Remove", style: .default) {_ in
                DataManage.shared.fetch(handle: { res, _ in
                    DataManage.shared.deleteByID(filmID: (self.movie?.id!)!, manageObj: res)
                    self.setButton()
                })
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func setButton() {
        if DataManage.shared.checkID((self.movie?.id!)!) {
            favouriteButton.setTitleColor(.red, for: .normal)
            favouriteButton.setTitle("Remove from favorite".capitalized, for: .normal)
        } else {
            favouriteButton.setTitleColor(.black, for: .normal)
            favouriteButton.setTitle("Add to favorite".capitalized, for: .normal)
        }

    }

}
