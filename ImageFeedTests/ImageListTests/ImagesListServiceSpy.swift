//
//  ImagesListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Main on 10.05.2025.
//

import Foundation
import ImageFeed

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var fetchPhotosNextPageCalled = false
    var photos: [Photo] = [] // Убрали private(set), чтобы был доступ к изменению
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func setPhotos(_ newPhotos: [Photo]) {
        photos = newPhotos
    }
}
