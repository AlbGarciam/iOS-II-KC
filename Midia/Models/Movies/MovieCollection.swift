//
//  MovieCollection.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 16/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

struct MovieCollection {
    let resultCount: Int
    let results: [Movie]?
}

extension MovieCollection: Decodable {
    
}
