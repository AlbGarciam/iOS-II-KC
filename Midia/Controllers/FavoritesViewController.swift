//
//  FavoritesViewController.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 11/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cells = UINib(nibName: FavoriteTableViewCell.reuseId, bundle: nil)
            tableView.register(cells, forCellReuseIdentifier: FavoriteTableViewCell.reuseId)
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var favorites: [MediaItemDetailProvidable] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let storedFavorites = Repository.shared.storageManager.favoritesProvidable?.getFavorites() {
            favorites = storedFavorites
        }
    }
    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else { fatalError("Cannot create DetailViewController") }
        
        let mediaItem = favorites[indexPath.row]
        detailViewController.mediaItemId = mediaItem.id
        present(detailViewController, animated: true, completion: nil)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseId, for: indexPath)
        (cell as? FavoriteTableViewCell)?.model = favorites[indexPath.row]
        return cell
    }
}
