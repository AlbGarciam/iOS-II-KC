//
//  Downloader.swift
//  AlbGarciam
//
//  Created by Alberto García-Muñoz on 18/02/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

typealias DownloadHandler = (Data?, Error?) -> Void

class NSURLSessionDownloader {
    static let shared: DownloaderProtocol = NSURLSessionDownloader()
    
    private let session : URLSession!
    init() {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
    }
}

extension NSURLSessionDownloader: DownloaderProtocol {
    func download<T>(from request: URLRequest, resultType: T.Type, completion: @escaping (DownloaderResult<T>) -> Void) where T : Decodable {
        NSLog("Requesting to \(request.url?.absoluteString ?? "No url")")
        let task = session.dataTask(with: request) { (data, response, error) in
            var result: DownloaderResult<T>
            if let error = error {
                result = .failure(error)
            } else if let json = data {
                do {
                    let model = try JSONDecoder().decode(T.self, from: json)
                    result = .success( model )
                } catch {
                    fatalError(error.localizedDescription)
                }
            } else {
                result = .success(nil)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
}
