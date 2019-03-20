//
//  BookCollection.swift
//  Midia
//
//  Created by Julio Martínez Ballester on 2/25/19.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

struct BookCollection {

    let kind: String
    let totalItems: Int
    let items: [Book]?

}

extension BookCollection: Decodable {

}
