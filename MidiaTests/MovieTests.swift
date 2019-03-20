//
//  MovieTests.swift
//  MidiaTests
//
//  Created by Alberto García-Muñoz on 16/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import XCTest
@testable import Midia

class MovieTests: XCTestCase {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let coverURL = URL(string: "http://books.google.com/books/content?id=qUW5js7ZD7UC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")
    var bestMovieEver: Movie!
    
    override func setUp() {
        super.setUp()
        
        bestMovieEver = Movie(movieId: 123, title: "Top Gun", author: "Mel gibson", releaseDate: Date(), synopsis: "Blah blah", coverURL: coverURL, rating: nil, numberOfReviews: nil, price: 30.5)
    }

    func testMovieExistence() {
        XCTAssertNotNil(bestMovieEver)
    }
    
    func testDecodeMovieCollection() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "movie-search-response", ofType: "json") else {
            XCTFail()
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let movieCollection = try decoder.decode(MovieCollection.self, from: data)
            XCTAssertNotNil(movieCollection)
            let firstMovie = movieCollection.results?.first!
            XCTAssertNotNil(firstMovie?.movieId)
            XCTAssertNotNil(firstMovie?.title)
        } catch {
            XCTFail()
        }
    }
    
    func testEncodeMovie() {
        do {
            let bookData = try encoder.encode(bestMovieEver)
            XCTAssertNotNil(bookData)
        } catch {
            XCTFail()
        }
    }
    
    func testDecodeEncodedDetailedMovie() {
        do {
            let bookData = try encoder.encode(bestMovieEver)
            XCTAssertNotNil(bookData)
            let movie = try decoder.decode(Movie.self, from: bookData)
            XCTAssertNotNil(movie)
            XCTAssertNotNil(movie.movieId)
            XCTAssertNotNil(movie.title)
            XCTAssertNotNil(movie.author)
            XCTAssertNotNil(movie.releaseDate)
            XCTAssertNotNil(movie.description)
            XCTAssertNotNil(movie.coverURL)
//            XCTAssertNotNil(movie.rating)
//            XCTAssertNotNil(movie.numberOfReviews)
            XCTAssertNotNil(movie.price)
        } catch {
            XCTFail()
        }
    }
    
    func testPersistOnUserDefaults() {
        let userDefaults = UserDefaults(suiteName: "testUD")!
        do {
            userDefaults.set(try encoder.encode(bestMovieEver), forKey: "Movie")
            userDefaults.synchronize()
            let bookData = userDefaults.data(forKey: "Movie")
            XCTAssertNotNil(bookData)
            let book = try decoder.decode(Movie.self, from: bookData!)
            XCTAssertNotNil(book)
        } catch {
            XCTFail()
        }
    }
}
