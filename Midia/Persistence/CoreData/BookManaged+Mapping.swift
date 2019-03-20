//
//  BookManaged+Mapping.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 13/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation
import CoreData

extension BookManaged {
    func mappedObject() -> Book {
        
        let authors = (self.authors?.allObjects as? [AuthorManaged])?.map{ $0.fullName! }
        let url = coverURL != nil ? URL(string: coverURL!) : nil
        
        return Book(bookId: bookId!, title: bookTitle!, authors: authors, publishedDate: publishedDate, description: description, coverURL: url, rating: rating, numberOfReviews: Int(numberOfReviews), price: price)
    }
}

extension BookManaged {
    func fill(with book: Book, context: NSManagedObjectContext) {
        self.bookId = book.bookId
        self.bookTitle = book.title
        self.publishedDate = book.publishedDate
        self.coverURL = book.coverURL?.absoluteString
        self.bookDescription = book.description
        if let rating = book.rating {
            self.rating = rating
        }
        if let price = book.price {
            self.price = price
        }
        if let numberOfReviews = book.numberOfReviews {
            self.numberOfReviews = Int32(numberOfReviews)
        }
        book.authors?.forEach({ (name) in
            let author = AuthorManaged(context: context)
            author.fullName = name
            addToAuthors(author)
        })
    }
}
