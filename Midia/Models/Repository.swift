//
//  Repository.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 17/03/2019.
//  Copyright © 2019 SoundApp. All rights reserved.
//

import Foundation

final class Repository {
    static let shared: Repository = Repository(mode: .book)
    
    let storageManager: StorageManager
    let mediaProvider: MediaItemProvider
    var mode: MediaItemKind {
        didSet {
            storageManager.mediaKind = mode
            mediaProvider.mediaItemKind = mode
        }
    }
    
    private init(mode: MediaItemKind) {
        self.mode = mode
        storageManager = StorageManager()
        storageManager.mediaKind = mode
        mediaProvider = MediaItemProvider(with: mode)
    }
    
}
