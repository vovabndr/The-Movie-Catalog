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
    @IBOutlet weak var searchSegmentControl: UISegmentedControl!
    
    var searchMovie = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        searchBar.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(Tap) )
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        searchSegmentControl.addTarget(self, action: #selector(search), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func Tap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func search(_ sender: UISegmentedControl){
        switch searchSegmentControl.selectedSegmentIndex {
        case 0:
            searchBar.keyboardType = .default
            break
        case 1:
            searchBar.keyboardType = .default
            break
        case 2:
            searchBar.keyboardType = .numberPad
            break
        default:
            break
        }
        clear()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return searchBar.resignFirstResponder()
    }
}

    // MARK: - TableView Delegate,DataSource
extension SearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMovie.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "\(indexPath.row)  " + searchMovie[indexPath.row].name!
        if indexPath.row == searchMovie.count - 1 {//, searchMovie.count < 100{
            searching()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = searchMovie[indexPath.row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
        controller.Movie = movie
        navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && searchMovie.count != 0{
            return "Search for \(searchBar.text!)"
        }
        return ""
    }

}

    // MARK: - SearchBarDelegate
extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching()
        resignFirstResponder()
        clear()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching()
        clear()
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location > 3 && searchSegmentControl.selectedSegmentIndex == 2{
            return false
        }else{
            return true
        }
    }
    
    func searching(){
        if searchBar.text == "" {
            searchMovie.removeAll()
            movieTableView.reloadData()
            return
        }
        
        var query = [String:AnyObject]()
        query["page"] = searchMovie.count/20 + 1 as AnyObject
        var parameter = String()
        switch searchSegmentControl.selectedSegmentIndex {
        case 0:
            query["query"] = searchBar.text! as AnyObject
            parameter = "/search/movie"
            break
        case 1:
            var genId = Int()
            parameter = "/discover/movie"

            for genre in Client.shared.getGenre(){
                if searchBar.text!.lowercased().range(of: genre.key.lowercased()) != nil{
                    genId = genre.value
                }
            }
            query["with_genres"] = genId as AnyObject
            break
        case 2:
            if let year = Int(searchBar.text!), searchBar.text?.count == 4, year > 1600 {
            query["primary_release_year"] = year as AnyObject
            parameter = "/discover/movie"
            }else{
                return
            }
            break
        default:
            return
        }
        
        Client.shared.GETMovies(parameter, query){ movies in
            if movies.count == 0 {
                return
            }
            for movie in movies{
                self.searchMovie.append(movie)
            }
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
                }
            }
        
        }
    
    func clear(){
        searchMovie.removeAll()
        movieTableView.reloadData()
    }
    
}

