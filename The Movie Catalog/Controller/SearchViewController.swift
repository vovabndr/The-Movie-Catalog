//
//  SearchViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/30/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        searchBar.delegate = self

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(Tap(_:)) )
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.tabBarController?.tabBar.isHidden = false

    }
    @objc func Tap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
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

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return searchBar.resignFirstResponder()
    }
}


extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Client.shared.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchCell", for: indexPath) as UITableViewCell
        let year = String((Client.shared.movieList[indexPath.row].release?.prefix(4))!)
        cell.textLabel?.text =  Client.shared.movieList[indexPath.row].name! + "(\(year))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = Client.shared.movieList[indexPath.row]
        self.performSegue(withIdentifier: "DetailVC", sender: movie)
    }
    
    
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

