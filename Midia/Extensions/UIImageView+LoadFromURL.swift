//
//  UIImageView+LoadFromURL.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 05/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(from url: URL?) {
        // Isolate the third party library
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceholderImage"))
//        Not usefull for collectionviews
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self?.image = image
//                }
//            }
//        }
    }
}
