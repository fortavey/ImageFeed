//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Main on 10.05.2025.
//

import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImageListPresenterProtocol {
    
    var view: ImageListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var fetchRequestCalled: Bool = false
    var dateFormatter: DateFormatter = .init()
    var imageListObserver: (any NSObjectProtocol)?
    var didSetLikeCallSuccess = false
    
    func fetchPhotosNextPage() {
        fetchRequestCalled = true
    }
    
    func imageListCellClickLike(_ cell: ImageFeed.ImagesListCell) {
        didSetLikeCallSuccess = true
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        fetchPhotosNextPage()
    }
}
