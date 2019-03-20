//
//  Movie.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 16/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

struct Movie {
    let movieId: Int
    let title: String
    let author: String?
    let releaseDate: Date?
    let synopsis: String?
    let coverURL: URL?
    let rating: Float?
    let numberOfReviews: Int?
    let price: Float?
    
    init(movieId: Int, title: String, author: String? = nil, releaseDate: Date? = nil, synopsis: String? = nil, coverURL: URL? = nil, rating: Float? = nil, numberOfReviews: Int? = nil, price: Float? = nil) {
        self.movieId = movieId
        self.title = title
        self.author = author
        self.releaseDate = releaseDate
        self.synopsis = synopsis
        self.coverURL = coverURL
        self.rating = rating
        self.numberOfReviews = numberOfReviews
        self.price = price
    }
}

extension Movie: MediaItemProvidable {
    var id: String {
        return String(movieId)
    }
    
    var imageURL: URL? {
        return coverURL
    }
}

extension Movie: MediaItemDetailProvidable {
    var creatorName: String? {
        return author
    }
    
    var reviews: Int? {
        return numberOfReviews
    }
    
    var creationDate: Date? {
        return releaseDate
    }
    
    var description: String? {
        return synopsis
    }
}

extension Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case trackId = "trackId"
        case trackName
        case trackPrice
        case longDescription
        case coverURL = "artworkUrl100"
        case artistName
        case releaseDate
        case numberOfReviews
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        movieId = try container.decode(Int.self, forKey: .trackId)
        title = try container.decode(String.self, forKey: .trackName)
        author = try container.decodeIfPresent(String.self, forKey: .artistName)
        
        if let releaseDateStr = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
            releaseDate = DateFormatter.movieFormatter.date(from: releaseDateStr)
        } else {
            releaseDate = nil
        }
        
        price = try container.decodeIfPresent(Float.self, forKey: .trackPrice)
        synopsis = try container.decodeIfPresent(String.self, forKey: .longDescription)
        coverURL = try container.decodeIfPresent(URL.self, forKey: .coverURL)
        
        numberOfReviews = nil // Not present in model
        rating = nil // Not present in model
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(movieId, forKey: .trackId)
        try container.encode(title, forKey: .trackName)
        try container.encodeIfPresent(author, forKey: .artistName)
        if let date = releaseDate {
            try container.encodeIfPresent(DateFormatter.movieFormatter.string(from: date), forKey: .releaseDate)
        }
        try container.encodeIfPresent(price, forKey: .trackPrice)
        try container.encodeIfPresent(synopsis, forKey: .longDescription)
        try container.encodeIfPresent(coverURL, forKey: .coverURL)
        try container.encodeIfPresent(numberOfReviews, forKey: .numberOfReviews)
        try container.encodeIfPresent(rating, forKey: .rating)
    }
}
