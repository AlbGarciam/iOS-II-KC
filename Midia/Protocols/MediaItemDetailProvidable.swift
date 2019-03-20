//
//  MediaItemDetailProvidable.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 06/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

protocol MediaItemDetailProvidable: ManageableProtocol {
    var id: String { get }
    var title: String { get }
    var imageURL: URL? { get }
    var creatorName: String? { get }
    var rating: Float? { get }
    var reviews: Int? { get }
    var creationDate: Date? { get }
    var price: Float? { get }
    var description: String? { get }
}
