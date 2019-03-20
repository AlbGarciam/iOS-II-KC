//
//  GoogleBooksMediaItemProviderNSURLSession.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 04/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

final class GoogleBooksMediaItemConsumableNSURLSession {
    let downloader = NSURLSessionDownloader.shared
}

extension GoogleBooksMediaItemConsumableNSURLSession : MediaItemAPIConsumable {
    func getLatestMedia(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        guard let request = GoogleBooksAPIConstants.buildRequest(with: "Game of thrones") else { return }
        downloader.download(from: request, resultType: BookCollection.self) { (result) in
            switch result {
            case .success(let model):
                success(model?.items ?? [])
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getMedia(with params: String, onSuccess success: @escaping ([MediaItemProvidable]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        guard let request = GoogleBooksAPIConstants.buildRequest(with: params) else { return }
        downloader.download(from: request, resultType: BookCollection.self) { (result) in
            switch result {
            case .success(let model):
                success(model?.items ?? [])
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getMediaItem(byId mediaItem: String, onSuccess success: @escaping (MediaItemDetailProvidable?) -> Void, onFailure failure: @escaping (Error) -> Void) {
        guard let request = GoogleBooksAPIConstants.buildRequest(for: mediaItem) else { return }
        downloader.download(from: request, resultType: Book.self) { (result) in
            switch result {
            case .success(let model):
                success(model)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
