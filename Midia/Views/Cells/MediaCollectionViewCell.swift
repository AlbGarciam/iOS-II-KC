//
//  BookCollectionViewCell.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 26/02/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    static let reuseId: String = "MediaCollectionViewCell"
    
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: MediaItemProvidable? {
        didSet {
            if let url = model?.imageURL {
                backgroundImageView.loadImage(from: url)
            }
            titleLabel.text = model?.title ?? ""
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.sd_cancelCurrentImageLoad()
    }
    
}
