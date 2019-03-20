//
//  Constants.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 04/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

struct GoogleBooksAPIConstants {
    static let SCHEMA = "https"
    static let HOST = "www.googleapis.com"
    static let PATH = "/books/v1/volumes"
    private static let API_KEY = "REPLACE_ME"
    
    static func buildRequest(with search: String) -> URLRequest? {
        if GoogleBooksAPIConstants.API_KEY == "REPLACE_ME" {
            fatalError("You have to replace the api key with your own KEY. After doing this, feel free to remove this line")
        }
        var components = URLComponents()
        components.scheme = GoogleBooksAPIConstants.SCHEMA
        components.host = GoogleBooksAPIConstants.HOST
        components.path = GoogleBooksAPIConstants.PATH
        components.queryItems = [URLQueryItem(name: "key", value: GoogleBooksAPIConstants.API_KEY),
                                 URLQueryItem(name: "q", value: search.replacingOccurrences(of: " ", with: "+"))]
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
    
    static func buildRequest(for book: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = GoogleBooksAPIConstants.SCHEMA
        components.host = GoogleBooksAPIConstants.HOST
        components.path = String(format: "%@/%@", GoogleBooksAPIConstants.PATH, book)
        components.queryItems = [URLQueryItem(name: "key", value: GoogleBooksAPIConstants.API_KEY)]
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}

struct ItunesAPIConstants {
    static let SCHEMA = "https"
    static let HOST = "itunes.apple.com"
    static let PATH_SEARCH = "/search"
    static let PATH_DETAILS = "/lookup"
    static let MEDIA_TYPE = "movie"
    static let COUNTRY = "es"
    static let MEDIA_TERM = "movieTerm"
    
    static func buildRequest(with search: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = ItunesAPIConstants.SCHEMA
        components.host = ItunesAPIConstants.HOST
        components.path = ItunesAPIConstants.PATH_SEARCH
        components.queryItems = [URLQueryItem(name: "media", value: ItunesAPIConstants.MEDIA_TYPE),
                                 URLQueryItem(name: "country", value: ItunesAPIConstants.COUNTRY),
                                 URLQueryItem(name: "attribute", value: ItunesAPIConstants.MEDIA_TERM),
                                 URLQueryItem(name: "term", value: search.replacingOccurrences(of: " ", with: "+"))]
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
    
    static func buildRequest(for movie: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = ItunesAPIConstants.SCHEMA
        components.host = ItunesAPIConstants.HOST
        components.path = ItunesAPIConstants.PATH_DETAILS
        components.queryItems = [URLQueryItem(name: "media", value: ItunesAPIConstants.MEDIA_TYPE),
                                 URLQueryItem(name: "country", value: ItunesAPIConstants.COUNTRY),
                                 URLQueryItem(name: "id", value: movie)]
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}
