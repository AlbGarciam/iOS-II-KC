//
//  FavoriteTableViewCell.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 11/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit
import SDWebImage

class FavoriteTableViewCell: UITableViewCell {
    static let reuseId = "FavoriteTableViewCell"
    //MARK: - UI elements
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var creators: UILabel!
    
    @IBOutlet weak var publishDate: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    var model: MediaItemDetailProvidable? {
        didSet {
            coverImage.sd_setImage(with: model?.imageURL, placeholderImage: UIImage(named: "Placeholder"), options: .forceTransition, completed: nil)
            title.text = model?.title
            if let creators = model?.creatorName {
                self.creators.text = creators
            } else {
                creators.isHidden = true
            }
            if let date = model?.creationDate {
                self.publishDate.text = "Released on: \(DateFormatter.bookFormatter.string(from: date))"
            } else {
                publishDate.isHidden = true
            }
            if let price = model?.price {
                self.price.text = "€ \(price)"
            } else {
                price.isHidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImage.sd_cancelCurrentImageLoad()
    }
}
