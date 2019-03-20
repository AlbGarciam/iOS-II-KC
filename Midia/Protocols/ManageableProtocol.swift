//
//  ManageableProtocol.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 16/03/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import Foundation
import CoreData

protocol ManageableProtocol {
    init?(from managed: NSManagedObject)
    func fill(object: NSManagedObject, context: NSManagedObjectContext?)
}

extension ManageableProtocol {
    init?(from managed: NSManagedObject) { return nil }
    func fill(object: NSManagedObject, context: NSManagedObjectContext?) { }
}
