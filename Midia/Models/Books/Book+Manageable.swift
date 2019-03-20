//
//  Book+Manageable.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 16/03/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import Foundation
import CoreData

extension Book: ManageableProtocol {
    
    init?(from managed: NSManagedObject) {
        guard let managed = managed as? BookManaged else { return nil }
        let authors = (managed.authors?.allObjects as? [AuthorManaged])?.map{ $0.fullName! }
        let url = managed.coverURL != nil ? URL(string: managed.coverURL!) : nil
        self.init(bookId: managed.bookId!,
                  title: managed.bookTitle!,
                  authors: authors,
                  publishedDate: managed.publishedDate,
                  description: managed.description,
                  coverURL: url,
                  rating: managed.rating,
                  numberOfReviews: Int(managed.numberOfReviews),
                  price: managed.price)
    }
    
    func fill(object: NSManagedObject, context: NSManagedObjectContext?) {
        guard let managed = object as? BookManaged else { return }
        managed.bookId = self.bookId
        managed.bookTitle = self.title
        managed.publishedDate = self.publishedDate
        managed.coverURL = self.coverURL?.absoluteString
        managed.bookDescription = self.description
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
            self.authors?.forEach({ (name) in
                let author = AuthorManaged(context: context)
                author.fullName = name
                managed.addToAuthors(author)
            })
        }
    }
}
