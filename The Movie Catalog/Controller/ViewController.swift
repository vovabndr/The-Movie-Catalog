//
//  ViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/26/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var MovieCollectionView: UICollectionView!

    var MovieList: [Movie] = []
    let refreshControl = UIRefreshControl()
    var movieImage = [Int:UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        MovieCollectionView.dataSource = self
        MovieCollectionView.delegate = self
        MovieCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        
   
    }
    
    @objc private func refreshData(_ sender: Any) {
//        update()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        update()
    }


    
    func update(){
        Client.shared.getPopular { movies in
            self.MovieList = movies
            DispatchQueue.main.async {
                self.MovieCollectionView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC"{
            if let vc = segue.destination as? DetailViewController{
                let movie = sender as? Movie
                vc.Movie = movie
            }
        }
    }
    
}


extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell{
            
            cell.movieImageView.image = UIImage(named: "background")

//            if  movieImage[indexPath.row] != nil {
//                cell.movieImageView.image = movieImage[indexPath.row]
//                print(indexPath.row,movieImage.count)
//
//            }else{
                cell.movieImageView.addImageFromURL(urlMovie: MovieList[indexPath.row].imageURL!)
//                movieImage[indexPath.row] = cell.movieImageView.image!
//            }
            
          if indexPath.row == MovieList.count-1{update()}

            return cell
        }
        
        return UICollectionViewCell()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = MovieList[indexPath.row]
        self.performSegue(withIdentifier: "DetailVC", sender: movie)
    }


    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.bounds.width/3 - 5, height: view.bounds.height/3);
//    }
        
    func addImageFromURL(urlMovie: String, handler: @escaping (UIImage)->()) {
        DispatchQueue.global(qos: .userInitiated).async {
            //
            if let url = URL(string: "https://image.tmdb.org/t/p/w780/"+urlMovie),
                //
                let imgData = try? Data(contentsOf: url),
                let img = UIImage(data: imgData){
                DispatchQueue.main.async{
                    handler( img)
                }
            }
        }
    }
    

    
    
}
