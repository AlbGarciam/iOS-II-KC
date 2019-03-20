//
//  MediaItemAPIConsumable.swift
//  Midia
//
//  Created by Alberto García-Muñoz on 28/02/2019.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import Foundation

protocol MediaItemAPIConsumable {
    
    func getLatestMedia(onSuccess success: @escaping ([MediaItemProvidable]) -> Void,
                        onFailure failure: @escaping (Error) -> Void )
    func getMedia(with params: String, onSuccess success: @escaping ([MediaItemProvidable]) -> Void,
                  onFailure failure: @escaping (Error) -> Void )
    func getMediaItem(byId mediaItem: String, onSuccess success: @escaping (MediaItemDetailProvidable?) -> Void,
                      onFailure failure: @escaping (Error) -> Void)
    
}
