//
//  Game.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 28/02/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

struct Game: MediaItemProvidable, MediaItemDetailProvidable {
    let title: String = "Titulo de prueba"
    let imageURL: URL? = URL(string: "http://books.google.com/books/content?id=qUW5js7ZD7UC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")!
    let id: String = "12456"
    let creatorName: String? = "Yo"
    let rating: Float? = nil
    let reviews: Int? = 33
    let creationDate: Date? = Date()
    let price: Float? = 4.50
    let description: String? = nil
}
