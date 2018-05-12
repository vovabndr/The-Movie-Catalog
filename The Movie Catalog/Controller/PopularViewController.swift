//
//  ViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/26/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {

    @IBOutlet weak var movieCollectionView: UICollectionView!

    var movieList: [Movie] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
    }

    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        update()
    }

    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    func update() {
        Client.shared.GETMovies("/movie/popular", ["page": self.movieList.count/20 + 1 as AnyObject]) { movies in
            for movie in movies {
                self.movieList.append(movie)
            }
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }

}

// MARK: - CollectionView Delegate,DataSource
extension PopularViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell",
                                                         for: indexPath) as? MovieCollectionViewCell {
            cell.movieImageView.image = UIImage(named: "background")

            cell.movieImageView.addImageFromURL(urlMovie: movieList[indexPath.row].imageURL)

            if indexPath.row == movieList.count-1 {
                update()
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movieList[indexPath.row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "DetailTableViewController")
            as? DetailTableViewController
        controller?.movie = movie
        navigationController!.pushViewController(controller!, animated: true)
    }
}
