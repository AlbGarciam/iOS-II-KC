//
//  MediaItemProvidable.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 28/02/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

protocol MediaItemProvidable {
    var id: String { get }
    var title: String { get }
    var imageURL: URL? { get }
}
