//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Main on 10.05.2025.
//

import Foundation

public protocol ImageListPresenterProtocol: AnyObject {
    var dateFormatter: DateFormatter { get set }
    var view: ImageListViewControllerProtocol? { get set }
    var imageListObserver: NSObjectProtocol? { get set }
    func imageListCellClickLike(_ cell: ImagesListCell)
    func viewDidLoad()
    func fetchPhotosNextPage()
}

final class ImageListPresenter: ImageListPresenterProtocol {
    var imagesListHelper: ImagesListHelperProtocol
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    var view: ImageListViewControllerProtocol?
    var imageListObserver: NSObjectProtocol?
    
    init(imagesListHelper: ImagesListHelperProtocol) {
        self.imagesListHelper = imagesListHelper
    }
    
    func viewDidLoad() {
        startImageListObserver()
        fetchPhotosNextPage()
    }
    
    func startImageListObserver(){
        imageListObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self, let view = self.view else { return }
            if let updatedPhotos = notification.userInfo?["photos"] as? [Photo] {
                view.photos = updatedPhotos
                view.updateTableViewAnimated()
            }
        }
    }
    
    func fetchPhotosNextPage() {
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    func imageListCellClickLike(_ cell: ImagesListCell) {
        guard let photo = cell.photo, let view else { return }
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            switch result {
            case .success(let photo):
                view.updateLikeUISuccess(cell: cell, photo: photo)
            case .failure(let error):
                print("[ImagesListCell]", "Ошибка сетевого запроса", error)
                view.updateLikeUIFailure()
            }
        }
    }
}
