//
//  FavouriteViewController.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 5/2/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController {
    @IBOutlet weak var dropTable: UITableView!

    var favourites: [Movie] = []
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        dropTable.delegate = self
        dropTable.dataSource = self
    }
    // MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManage.shared.fetch { _, result in
            self.favourites = result
            self.dropTable.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

    // MARK: - Delegate, DataSource
extension FavouriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath)
        if let text = favourites[indexPath.row].name {
            cell.textLabel?.text = text
        }
        if let poster = UIImage(data: (favourites[indexPath.row].image)!) {
            cell.imageView?.image = poster
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier:
            "DetailTableViewController") as? DetailTableViewController
        controller?.movie = favourites[indexPath.row]
        navigationController!.pushViewController(controller!, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManage.shared.fetch { manage, _ in
            DataManage.shared.delete(index: indexPath.row, manageObj: manage)
            DataManage.shared.fetch { _, res  in
                self.favourites = res
                self.dropTable.reloadData()
                }
            }
        }
    }
}
