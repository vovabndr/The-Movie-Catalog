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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func Tap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func search(_ sender: UISegmentedControl){
        switch searchSegmentControl.selectedSegmentIndex {
        case 0:
            print(0)
            break
        case 1:
            print(1)
            break
        case 2:
            print(2)
            break
        default:
            break
        }
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
        let year = String((searchMovie[indexPath.row].release?.prefix(4))!)
        cell.textLabel?.text =  searchMovie[indexPath.row].name! + "(\(year))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = searchMovie[indexPath.row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "DetailTableViewController") as! DetailTableViewController
        controller.Movie = movie
        navigationController!.pushViewController(controller, animated: true)
    }
}

    // MARK: - SearchBarDelegate
extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching()
        resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching()
    }
    func searching(){
        if searchBar.text != "" {
        Client.shared.searchMovies(searchBar.text!) { (movies) in
            self.searchMovie = movies
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
                }
            }
        } else{
            self.searchMovie.removeAll()
            self.movieTableView.reloadData()
        }
    }
}
