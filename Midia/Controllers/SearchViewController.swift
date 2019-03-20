//
//  SearchViewController.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 06/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    fileprivate var mediaItems: [MediaItemProvidable] = [] {
        didSet {
            state = mediaItems.count == 0 ? .noResults : .success
            collectionView.reloadData()
        }
    }
    
    var state : LoadingState = .success {
        willSet {
            guard state != newValue else { return }
            [activityIndicator, collectionView, statusLabel, statusSublabel].forEach { $0?.isHidden = true }
            newValue == .loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            
            switch newValue {
            case .loading:
                activityIndicator.isHidden = false
                statusLabel.isHidden = false
                statusLabel.text = "🤔"
                statusSublabel.isHidden = false
                statusSublabel.text = "Loading"
            case .failure:
                statusLabel.isHidden = false
                statusLabel.text = "🥺"
                statusSublabel.isHidden = false
                statusSublabel.text = "Failure"
            case .noResults:
                statusLabel.isHidden = false
                statusLabel.text = "📦"
                statusSublabel.isHidden = false
                statusSublabel.text = "No results"
            case .success:
                collectionView.isHidden = false
                collectionView.reloadData()
            }
        }
    }
    
    var mediaItemProvider: MediaItemProvider!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusSublabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
            let cellNib = UINib(nibName: "MediaCollectionViewCell", bundle: nil)
            collectionView.register(cellNib, forCellWithReuseIdentifier: MediaCollectionViewCell.reuseId)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "The lord of rings"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .noResults
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.reuseId,
                                                      for: indexPath)
        let item = mediaItems[indexPath.item]
        
        if let cell = cell as? MediaCollectionViewCell {
            cell.model = item
        }
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else { fatalError("Cannot create DetailViewController") }
        
        let mediaItem = mediaItems[indexPath.item]
        detailViewController.mediaItemId = mediaItem.id
        detailViewController.mediaItemProvider = mediaItemProvider
        
        present(detailViewController, animated: true, completion: nil)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 200)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        mediaItemProvider.getHomeMediaItems(with: searchText, onSuccess: { [weak self] items in
            self?.mediaItems = items
        }) { [weak self] items in
            self?.state = .failure
        }
    }
}
