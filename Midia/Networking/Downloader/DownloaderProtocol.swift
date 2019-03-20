//
//  DownloaderProtocol.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 16/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

protocol DownloaderProtocol: AnyObject {
    func download<T:Decodable>(from url: URL, resultType: T.Type, completion: @escaping (DownloaderResult<T>) -> Void )
    func download<T:Decodable>(from request: URLRequest, resultType: T.Type, completion: @escaping (DownloaderResult<T>) -> Void )
}

// Override default behaviour
extension DownloaderProtocol {
    func download<T>(from url: URL, resultType: T.Type, completion: @escaping (DownloaderResult<T>) -> Void ) {
        let urlRequest = URLRequest(url: url)
        self.download(from: urlRequest, resultType: resultType, completion: completion)
    }
}

enum DownloaderResult<T: Decodable> {
    case success(T?)
    case failure(Error)
}
