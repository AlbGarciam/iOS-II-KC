//
//  FavoritesProvidable.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 11/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

protocol FavoritesProvidable: AnyObject {
    func getFavorites() -> [MediaItemDetailProvidable]?
    func getFavorite(by id: String) -> MediaItemDetailProvidable?
    func add(favorite: MediaItemDetailProvidable)
    func remove(with id: String)
}
