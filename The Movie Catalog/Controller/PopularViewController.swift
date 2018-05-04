//
//  ViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/26/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {

    
    @IBOutlet weak var MovieCollectionView: UICollectionView!

    var MovieList: [Movie] = []
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieCollectionView.dataSource = self
        MovieCollectionView.delegate = self
    }
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        update()
    }
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func update(){
        Client.shared.getPopular(self.MovieList.count/20 + 1) { movies in
            for movie in movies{
                self.MovieList.append(movie)                
            }
            DispatchQueue.main.async {
                self.MovieCollectionView.reloadData()
           }
        }
    }
}

// MARK: - CollectionView Delegate,DataSource
extension PopularViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell{
            cell.movieImageView.image = UIImage(named: "background")
            cell.movieImageView.addImageFromURL(urlMovie: MovieList[indexPath.row].imageURL!)
            if indexPath.row == MovieList.count-1{
                update()
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = MovieList[indexPath.row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
        controller.Movie = movie
        navigationController!.pushViewController(controller, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.bounds.width/3 - 5, height: view.bounds.height/3);
//    }
}
