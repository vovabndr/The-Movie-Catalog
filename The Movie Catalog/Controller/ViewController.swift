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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieCollectionView.dataSource = self
        MovieCollectionView.delegate = self
        MovieCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
}


extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell{
          withBigImage(urlMovie: MovieList[indexPath.row].imageURL! ) { (image) in
                cell.movieImageView.image = image
            }
            
            if indexPath.row == MovieList.count-1{update()}
            
            cell.movieLabel.text = MovieList[indexPath.row].name
            return cell
        }
        
        return UICollectionViewCell()
    }
    

    
    
    
    
    
    func withBigImage(urlMovie: String ,completionHandler handler: @escaping (_ image: UIImage) -> () ){
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlMovie),
                let imgData = try? Data(contentsOf: url),
                let img = UIImage(data: imgData){
                DispatchQueue.main.async(execute: {
                    handler(img)
                })
            }
        }
    }
    
    
    
    
}
