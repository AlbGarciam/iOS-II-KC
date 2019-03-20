//
//  Movie+Manageable.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 16/03/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import Foundation
import CoreData

extension Movie: ManageableProtocol {
    
    init?(from managed: NSManagedObject) {
        guard let managed = managed as? MovieManaged else { return nil }
        let authors = managed.author?.fullName
        let url = managed.coverURL != nil ? URL(string: managed.coverURL!) : nil
        self.init(movieId: Int(managed.movieId),
                  title: managed.title!,
                  author: authors,
                  releaseDate: managed.releaseDate,
                  synopsis: managed.synopsis,
                  coverURL: url,
                  rating: managed.rating,
                  numberOfReviews: Int(managed.numberOfReviews),
                  price: managed.price)
    }
    
    func fill(object: NSManagedObject, context: NSManagedObjectContext?) {
        guard let managed = object as? MovieManaged else { return }
        managed.movieId = Int32(self.movieId)
        managed.title = self.title
        managed.releaseDate = self.releaseDate
        managed.coverURL = self.coverURL?.absoluteString
        managed.synopsis = self.description
        if let rating = self.rating {
            managed.rating = rating
        }
        if let price = self.price {
            managed.price = price
        }
        if let numberOfReviews = self.numberOfReviews {
            managed.numberOfReviews = Int32(numberOfReviews)
        }
        if let context = context {
            let author = AuthorManaged(context: context)
            author.fullName = self.author
            managed.author = author
        }
    }
}
