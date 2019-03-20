//
//  CoreDataStack.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 13/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        })
        return container
    }()
}
