//
//  UserDefaultsStorageManager.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 11/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

class UserDefaultsStorageManager<Providable: MediaItemDetailProvidable & Codable> {
    let userDefaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    private var collectionKey: String {
        return "favourite_\(Providable.self)"
    }
    
    private func save(_ media: [MediaItemDetailProvidable]) {
        do {
            switch Providable.self {
            case is Book.Type, is Movie.Type:
                userDefaults.set(try encoder.encode(media as! [Providable]), forKey: collectionKey)
            default:
                fatalError("Media kind (\(Providable.self)) not yet supported")
            }
            userDefaults.synchronize()
        } catch {
            fatalError("Media kind (\(Providable.self)) not yet supported")
        }
        
    }
}

extension UserDefaultsStorageManager: FavoritesProvidable {
    func getFavorites() -> [MediaItemDetailProvidable]? {
        guard let favoritesData = userDefaults.data(forKey: collectionKey) else { return nil }
        return try? decoder.decode([Providable].self, from: favoritesData)
    }
    
    func getFavorite(by id: String) -> MediaItemDetailProvidable? {
        return getFavorites()?.filter{ $0.id == id }.first
    }
    
    func add(favorite: MediaItemDetailProvidable) {
        guard getFavorite(by: favorite.id) == nil else { return }
        if var favorites = getFavorites() {
            favorites.append(favorite)
            save(favorites)
        } else {
            save([favorite])
        }
    }
    
    func remove(with id: String) {
        guard let favorites = getFavorites()?.filter({ $0.id != id }) else { return }
        save(favorites)
    }
}
