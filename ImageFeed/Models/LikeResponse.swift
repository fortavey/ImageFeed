//
//  LikeResponse.swift
//  ImageFeed
//
//  Created by Main on 08.05.2025.
//

import Foundation

struct LikeResponse: Decodable {
    let photo: LikePhoto
}

struct LikePhoto: Decodable {
    let id: String
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case likedByUser = "liked_by_user"
    }
}
