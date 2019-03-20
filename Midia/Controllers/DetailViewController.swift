//
//  DetailViewController.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 06/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var addFavouriteButton: UIButton! {
        didSet {
            addFavouriteButton.addTarget(self, action: #selector(toggleFavorites(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var creatorsLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var ratingsContainer: UIStackView!
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                addFavouriteButton.setTitle("Remove favorite", for: .normal)
            } else {
                addFavouriteButton.setTitle("Add to favorites", for: .normal)
            }
        }
    }
    
    var mediaItemId: String!
    var mediaItemProvider: MediaItemProvider?
    var detail: MediaItemDetailProvidable? {
        willSet {
            guard let detail = newValue else { return }
            titleLabel.text = detail.title
            imageView.loadImage(from: detail.imageURL)
            creatorsLabel.text = detail.creatorName ?? "Anonym"
            
            if let ratingValue = detail.rating, let reviewsValue = detail.reviews {
                rating.text = "\(ratingValue)"
                reviews.text = "\(reviewsValue) reviews"
                ratingsContainer.isHidden = false
            } else {
                ratingsContainer.isHidden = true
            }
            
            if let creationDate = detail.creationDate {
                releaseDate.text = "Published on: \(DateFormatter.bookFormatter.string(from: creationDate))"
            } else {
                releaseDate.isHidden = true
            }
            
            if let price = detail.price {
                buyButton.setTitle("Buy for €\(price)", for: .normal)
            } else {
                buyButton.isHidden = true
            }
            descriptionText.text = detail.description
            isFavorite = Repository.shared.storageManager.favoritesProvidable?.getFavorite(by: detail.id) != nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let favorite = Repository.shared.storageManager.favoritesProvidable?.getFavorite(by: mediaItemId) {
            detail = favorite
            loadingView.isHidden = true
        } else { // Refactor ...
            mediaItemProvider?.getDetailItem(with: mediaItemId, onSuccess: { [weak self] (item) in
                self?.loadingView.isHidden = true
                self?.detail = item
            }) { [weak self] (error) in
                self?.loadingView.isHidden = true
                let alertController = UIAlertController(title: "Error", message: "Ha ocurrido un error", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self?.dismiss(animated: true, completion: nil)
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Actions
    @objc private func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func toggleFavorites(_ sender: Any) {
        guard let detail = detail else { return }
        if isFavorite { // Remove
            Repository.shared.storageManager.favoritesProvidable?.remove(with: detail.id)
        } else { // Add
            Repository.shared.storageManager.favoritesProvidable?.add(favorite: detail)
        }
        isFavorite = !isFavorite
    }
}
