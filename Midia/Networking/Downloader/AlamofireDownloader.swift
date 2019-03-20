//
//  AlamofireDownloader.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 16/03/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation
import Alamofire

final class AlamofireDownloader : DownloaderProtocol{
    static let shared: DownloaderProtocol = AlamofireDownloader()
    
    func download<T>(from request: URLRequest, resultType: T.Type, completion: @escaping (DownloaderResult<T>) -> Void) where T : Decodable {
        Alamofire.request(request).responseData { (response) in
            var result : DownloaderResult<T>
            switch response.result {
            case .failure(let error):
                result = .failure(error)
            case .success(let value):
                result = .success( try? JSONDecoder().decode(T.self, from: value) )
            }
            completion(result)
        }
    }
}
