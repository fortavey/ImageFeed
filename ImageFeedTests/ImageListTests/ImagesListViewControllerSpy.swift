//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Main on 10.05.2025.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImageListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol?
    var photos: [Photo] = []
    
    func updateTableViewAnimated() {
        
    }
    
    func updateLikeUISuccess(cell: ImageFeed.ImagesListCell, photo: ImageFeed.Photo) {
        
    }
    
    func updateLikeUIFailure() {
        
    }
    
    var updateTableViewCalled = false
    var reloadCellCalled = false
    
    func updateTableView() {
        updateTableViewCalled = true
    }
    
    func reloadCell(at indexPath: IndexPath) {
        reloadCellCalled = true
    }
}
