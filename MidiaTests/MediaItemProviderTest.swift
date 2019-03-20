//
//  MediaItemProviderTest.swift
//  MidiaTests
//
//  Created by Alberto García-Muñoz on 04/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import XCTest
@testable import Midia

class MediaItemProviderTest: XCTestCase {
    var mediaItemProvider: MediaItemProvider!
    var mockConsumer = MockMediaItemAPIConsumer()
    
    override func setUp() {
        mediaItemProvider = MediaItemProvider(with: .book, apiConsumer: mockConsumer)
    }
    
    func testGetHomeMediaItemProviderShouldReturnItems() {
        mediaItemProvider.getHomeMediaItems(onSuccess: { (items) in
            XCTAssertNotNil(items)
            XCTAssert(items.count > 0)
            XCTAssertNotNil(items.first?.title)
        }) { (_) in
            XCTFail()
        }
    }
    
}

struct MockMediaItem: MediaItemProvidable {
    var id: String = "1234"
    var title: String = "A title"
    var imageURL: URL? = nil
}

struct MockMediaDetail: MediaItemDetailProvidable {
    var id: String = "1234"
    
    var title: String = "A title"
    
    var imageURL: URL? = nil
    
    var creatorName: String? = nil
    
    var rating: Float? = nil
    
    var reviews: Int? = nil
    
    var creationDate: Date? = nil
    
    var price: Float? = nil
    
    var description: String?  = nil
}

final class MockMediaItemAPIConsumer: MediaItemAPIConsumable {
    func getMedia(with params: String, onSuccess success: @escaping ([MediaItemProvidable]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let items = [MockMediaItem(), MockMediaItem()]
        success(items)
    }
    
    func getMediaItem(byId mediaItem: String, onSuccess success: @escaping (MediaItemDetailProvidable?) -> Void, onFailure failure: @escaping (Error) -> Void) {
        success(MockMediaDetail())
    }
    
    func getLatestMedia(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let items = [MockMediaItem(), MockMediaItem()]
        success(items)
    }
    
}
