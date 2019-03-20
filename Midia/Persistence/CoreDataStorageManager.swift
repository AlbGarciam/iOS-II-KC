//
//  CoreDataStorageManager.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 13/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation
import CoreData

//TODO: Add abstraction layer to use mediaItems

final class CoreDataStorageManager<Providable: MediaItemDetailProvidable & Codable> {
    unowned let stack = CoreDataStack.shared
}

extension CoreDataStorageManager : FavoritesProvidable {
    func getFavorites() -> [MediaItemDetailProvidable]? {
        let context = stack.persistentContainer.viewContext
        switch Providable.self {
        case is Book.Type:
            let fetch : NSFetchRequest<BookManaged> = BookManaged.fetchRequest()
            let dateSortDescriptor = NSSortDescriptor(key: "publishedDate", ascending: true)
            let priceSortDescriptor = NSSortDescriptor(key: "price", ascending: false)
            fetch.sortDescriptors = [dateSortDescriptor, priceSortDescriptor]
            do {
                return try context.fetch(fetch).compactMap{Providable(from: $0)}
            } catch {
                assertionFailure("Error fetching media items: \(error)")
                return nil
            }
        case is Movie.Type:
            let fetch : NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
            let dateSortDescriptor = NSSortDescriptor(key: "releaseDate", ascending: true)
            let priceSortDescriptor = NSSortDescriptor(key: "price", ascending: false)
            fetch.sortDescriptors = [dateSortDescriptor, priceSortDescriptor]
            do {
                return try context.fetch(fetch).compactMap{Providable(from: $0)}
            } catch {
                assertionFailure("Error fetching media items: \(error)")
                return nil
            }
        default:
            fatalError("\(Providable.self) is not supported")
        }
    }
    
    func getFavorite(by id: String) -> MediaItemDetailProvidable? {
        let context = stack.persistentContainer.viewContext
        switch Providable.self {
        case is Book.Type:
            let fetch : NSFetchRequest<BookManaged> = BookManaged.fetchRequest()
            let predicate = NSPredicate(format: "bookId == %@", id)
            fetch.predicate = predicate
            do {
                guard let lastItem = try context.fetch(fetch).last else { return nil }
                return Providable(from: lastItem)
            } catch {
                assertionFailure("Error fetching media items: \(error)")
                return nil
            }
        case is Movie.Type:
            let fetch : NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
            let predicate = NSPredicate(format: "movieId == %@", id)
            fetch.predicate = predicate
            do {
                guard let lastItem = try context.fetch(fetch).last else { return nil }
                return Providable(from: lastItem)
            } catch {
                assertionFailure("Error fetching media items: \(error)")
                return nil
            }
        default:
            fatalError("\(Providable.self) is not supported")
        }
    }
    
    func add(favorite: MediaItemDetailProvidable) {
        let context = stack.persistentContainer.viewContext
        switch Providable.self {
        case is Book.Type:
            let bookManaged = BookManaged(context: context)
            favorite.fill(object: bookManaged, context: context)
        case is Movie.Type:
            let bookManaged = MovieManaged(context: context)
            favorite.fill(object: bookManaged, context: context)
        default:
            fatalError("\(Providable.self) is not supported")
        }
        do {
            try context.save()
        } catch {
            assertionFailure("Error fetching by id: \(error)")
        }
    }
    
    func remove(with id: String) {
        let context = stack.persistentContainer.viewContext
        var favorites: [NSManagedObject]?
        switch Providable.self {
        case is Book.Type:
            let fetch : NSFetchRequest<BookManaged> = BookManaged.fetchRequest()
            let predicate = NSPredicate(format: "bookId == %@", id)
            fetch.predicate = predicate
            favorites = try? context.fetch(fetch)
        case is Movie.Type:
            let fetch: NSFetchRequest<MovieManaged> = MovieManaged.fetchRequest()
            let predicate = NSPredicate(format: "movieId == %@", id)
            fetch.predicate = predicate
            favorites = try? context.fetch(fetch)
        default:
            fatalError("\(Providable.self) is not supported")
        }
        do {
            favorites?.forEach{ favorite in
                context.delete(favorite)
            }
            try context.save()
        } catch {
            assertionFailure("Error fetching by id: \(error)")
        }

    }
}
