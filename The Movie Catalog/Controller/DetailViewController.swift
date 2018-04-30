//
//  DetailViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/28/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var posterImageView: UIImageView!{
        didSet{
            posterImageView.addImageFromURL(urlMovie: (Movie?.backdrop)!)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.text = Movie?.name
        }
    }
    @IBOutlet weak var ratedView: RatingView!{
        didSet{
            ratedView.set(vote: (Movie?.vote!)!)
        }
    }
    
    @IBOutlet weak var overviewTextView: UITextView!{
        didSet{
            self.overviewTextView.text = Movie?.overview
        }
    }
    
    var Movie: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    



}
