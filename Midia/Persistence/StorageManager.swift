//
//  StorageManager.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 11/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

class StorageManager {
    private(set) var favoritesProvidable: FavoritesProvidable?
        
    var mediaKind: MediaItemKind? {
        didSet {
            guard let mediaKind = mediaKind else { return }
            switch mediaKind {
            case .book:
                favoritesProvidable = CoreDataStorageManager<Book>()
            case .movie:
                favoritesProvidable = CoreDataStorageManager<Movie>()
            default:
                assertionFailure("This mode is not supported")
            }
        }
    }
}
