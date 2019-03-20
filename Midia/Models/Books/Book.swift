//
//  Book.swift
//  Midia
//
//  Created by Julio Martínez Ballester on 2/25/19.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

struct Book {

    let bookId: String
    let title: String
    let authors: [String]?
    let publishedDate: Date?
    let description: String?
    let coverURL: URL?
    let rating: Float?
    let numberOfReviews: Int?
    let price: Float?

    init(bookId: String, title: String, authors: [String]? = nil, publishedDate: Date? = nil, description: String? = nil, coverURL: URL? = nil, rating: Float? = nil, numberOfReviews: Int? = nil, price: Float? = nil) {
        self.bookId = bookId
        self.title = title
        self.authors = authors
        self.publishedDate = publishedDate
        self.description = description
        self.coverURL = coverURL
        self.rating = rating
        self.numberOfReviews = numberOfReviews
        self.price = price
    }
}

extension Book: Codable {

    enum CodingKeys: String, CodingKey {
        case bookId = "id"
        case volumeInfo
        case title
        case authors
        case publishedDate
        case description
        case imageLinks = "imageLinks"
        case coverURL = "thumbnail"
        case rating = "averageRating"
        case numberOfReviews = "ratingsCount"
        case saleInfo
        case listPrice
        case price = "amount"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        bookId = try container.decode(String.self, forKey: .bookId)

        let volumeInfo = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        title = try volumeInfo.decode(String.self, forKey: .title)
        authors = try volumeInfo.decodeIfPresent([String].self, forKey: .authors)

        let publishDateStr = try volumeInfo.decodeIfPresent(String.self, forKey: .publishedDate)
        publishedDate = publishDateStr != nil ? DateFormatter.bookFormatter.date(from: publishDateStr!) : nil
        
        
        description = try volumeInfo.decodeIfPresent(String.self, forKey: .description)
        
        // It is possible that we don't have imageLinks. That's why we use the try? to not throw an error
        // of decoding when item doesn't contain cover url
        let imageContainer = try? volumeInfo.nestedContainer(keyedBy: Book.CodingKeys.self, forKey: .imageLinks)
        coverURL = try imageContainer?.decodeIfPresent(URL.self, forKey: .coverURL)
        
        rating = try volumeInfo.decodeIfPresent(Float.self, forKey: .rating)
        numberOfReviews = try volumeInfo.decodeIfPresent(Int.self, forKey: .numberOfReviews)
        
        let salesInfoContainer = try? container.nestedContainer(keyedBy: Book.CodingKeys.self, forKey: .saleInfo)
        let listPricesContainer = try? salesInfoContainer?.nestedContainer(keyedBy: Book.CodingKeys.self, forKey: .listPrice)
        price = try listPricesContainer??.decodeIfPresent(Float.self, forKey: .price)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bookId, forKey: .bookId)
        var volumeContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        try volumeContainer.encode(title, forKey: .title)
        try volumeContainer.encodeIfPresent(authors, forKey: .authors)
        if let date = publishedDate {
            try volumeContainer.encodeIfPresent(DateFormatter.bookFormatter.string(from: date), forKey: .publishedDate)
        }
        try volumeContainer.encodeIfPresent(description, forKey: .description)
        var imageContainer = volumeContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageLinks)
        try imageContainer.encodeIfPresent(coverURL, forKey: .coverURL)
        try volumeContainer.encodeIfPresent(rating, forKey: .rating)
        try volumeContainer.encodeIfPresent(numberOfReviews, forKey: .numberOfReviews)
        var volumeSalesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .saleInfo)
        var listPricesContainer = volumeSalesContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .listPrice)
        try listPricesContainer.encodeIfPresent(price, forKey: .price)
    }

}

extension Book: MediaItemProvidable {
    var id: String {
        return bookId
    }
    
    var imageURL: URL? {
        return coverURL
    }
}

extension Book: MediaItemDetailProvidable {
    var creatorName: String? {
        return authors?.joined(separator: ", ")
    }
    
    var reviews: Int? {
        return numberOfReviews
    }
    
    var creationDate: Date? {
        return publishedDate
    }
}
