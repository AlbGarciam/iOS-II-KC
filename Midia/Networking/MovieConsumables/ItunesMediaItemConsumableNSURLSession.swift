//
//  GoogleBooksMediaItemProviderNSURLSession.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 04/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

final class ItunesMediaItemConsumableNSURLSession {
    let downloader = NSURLSessionDownloader.shared
}

extension ItunesMediaItemConsumableNSURLSession : MediaItemAPIConsumable {
    func getLatestMedia(onSuccess success: @escaping ([MediaItemProvidable]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        guard let request = ItunesAPIConstants.buildRequest(with: "Top") else { return }
        downloader.download(from: request, resultType: MovieCollection.self) { (result) in
            switch result {
            case .success(let model):
                success(model?.results ?? [])
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getMedia(with params: String, onSuccess success: @escaping ([MediaItemProvidable]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        guard let request = ItunesAPIConstants.buildRequest(with: params) else { return }
        downloader.download(from: request, resultType: MovieCollection.self) { (result) in
            switch result {
            case .success(let model):
                success(model?.results ?? [])
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getMediaItem(byId mediaItem: String, onSuccess success: @escaping (MediaItemDetailProvidable?) -> Void, onFailure failure: @escaping (Error) -> Void) {
        guard let request = ItunesAPIConstants.buildRequest(for: mediaItem) else { return }
        downloader.download(from: request, resultType: MovieCollection.self) { (result) in
            switch result {
            case .success(let model):
                success(model?.results?.first)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
