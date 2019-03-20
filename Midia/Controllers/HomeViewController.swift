//
//  HomeViewController.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 26/02/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusSubLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal  // .vertical
            }
            let cellNib = UINib(nibName: "MediaCollectionViewCell", bundle: nil)
            collectionView.register(cellNib, forCellWithReuseIdentifier: MediaCollectionViewCell.reuseId)
        }
    }
    
    var state : LoadingState = .success {
        willSet {
            guard state != newValue else { return }
            [activityIndicator, collectionView, statusLabel, statusSubLabel].forEach { $0?.isHidden = true }
            newValue == .loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            
            switch newValue {
            case .loading:
                activityIndicator.isHidden = false
                statusLabel.isHidden = false
                statusLabel.text = "🤔"
                statusSubLabel.isHidden = false
                statusSubLabel.text = "Loading"
            case .failure:
                statusLabel.isHidden = false
                statusLabel.text = "🥺"
                statusSubLabel.isHidden = false
                statusSubLabel.text = "Failure"
            case .noResults:
                statusLabel.isHidden = false
                statusLabel.text = "📦"
                statusSubLabel.isHidden = false
                statusSubLabel.text = "No results"
            case .success:
                collectionView.isHidden = false
                collectionView.reloadData()
            }
        }
    }
    
    fileprivate var mediaItems: [MediaItemProvidable] = [] {
        didSet {
            state = mediaItems.count == 0 ? .noResults : .success
        }
    }
    var mediaItemProvider: MediaItemProvider!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        state = .loading
        mediaItemProvider.getHomeMediaItems(onSuccess: { [weak self] (items) in
            self?.mediaItems = items
        }) { [weak self] (error) in
            self?.state = .failure
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
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

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else { fatalError("Cannot create DetailViewController") }
        
        let mediaItem = mediaItems[indexPath.item]
        detailViewController.mediaItemId = mediaItem.id
        detailViewController.mediaItemProvider = mediaItemProvider
        
        present(detailViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 200)
    }
}
