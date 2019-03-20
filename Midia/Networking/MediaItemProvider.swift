//
//  MediaItemProvider.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 28/02/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

final class MediaItemProvider {
    var mediaItemKind: MediaItemKind { // Not called during init
        willSet {
            guard mediaItemKind != newValue else { return }
            switch newValue {
            case .book:
                apiConsumer = GoogleBooksMediaItemConsumableAlamofire()
            case .game:
                fatalError("Game type is not supported (Coming soon)")
            case .movie:
                apiConsumer = ItunesMediaItemConsumableNSURLSession()
            }
        }
    }
    private(set) var apiConsumer: MediaItemAPIConsumable
    
    init(with mediaItemKind: MediaItemKind, apiConsumer: MediaItemAPIConsumable) {
        self.mediaItemKind = mediaItemKind
        self.apiConsumer = apiConsumer
    }
    
    convenience init(with mediaItemKind: MediaItemKind) {
        switch mediaItemKind {
        case .book:
            self.init(with: mediaItemKind, apiConsumer: GoogleBooksMediaItemConsumableAlamofire())
        case .game:
            fatalError("Game type is not supported (Coming soon)")
        case .movie:
            self.init(with: mediaItemKind, apiConsumer: ItunesMediaItemConsumableNSURLSession())
        }
    }
    
    func getHomeMediaItems(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        apiConsumer.getLatestMedia(onSuccess: { (mediaItems) in
            assert(Thread.current == Thread.main, "Current thread: \(Thread.current)") // ensure we are in main thread
            success(mediaItems)
        }) { (error) in
            assert(Thread.current == Thread.main, "Current thread: \(Thread.current)") // ensure we are in main thread
            failure(error)
        }
    }
    
    func getHomeMediaItems(with text: String, onSuccess success: @escaping ([MediaItemProvidable]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        apiConsumer.getMedia(with: text, onSuccess: { (mediaItems) in
            assert(Thread.current == Thread.main, "Current thread: \(Thread.current)") // ensure we are in main thread
            success(mediaItems)
        }) { (error) in
            assert(Thread.current == Thread.main, "Current thread: \(Thread.current)") // ensure we are in main thread
            failure(error)
        }
    }
    
    func getDetailItem(with id: String, onSuccess success: @escaping (MediaItemDetailProvidable?) -> Void, onFailure failure: @escaping (Error) -> Void) {
        apiConsumer.getMediaItem(byId: id, onSuccess: { (mediaItem) in
            assert(Thread.current == Thread.main, "Current thread: \(Thread.current)") // ensure we are in main thread
            success(mediaItem)
        }) { (error) in
            assert(Thread.current == Thread.main, "Current thread: \(Thread.current)") // ensure we are in main thread
            failure(error)
        }
    }
}
