//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Main on 06.05.2025.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private init(){}
    
    private lazy var dateFormatter = ISO8601DateFormatter()
    
    private var networkClient = NetworkClient()
    
    private(set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var currentPage: Int = 0
    
    func clear(){
        photos = []
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage.shared.token else {
            print("[ImagesListService]", "Отсутствует токен")
            return
        }
        if networkClient.task != nil { return }
        
        let request = makePhotosNextPageRequest(token: token, nextPage: currentPage + 1)
        
        guard let request else {
            assertionFailure("Ошибка получения PhotosNextPageRequest")
            return
        }
        
        networkClient.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let arr):
                addPhotos(from: arr)
                self.currentPage += 1
            case .failure(let error):
                print("[ImagesListService]", "Ошибка сетевого запроса", error)
            }
            self.networkClient.task = nil
        }
    }
    
    func makePhotosNextPageRequest(token: String, nextPage: Int) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: "\(Constants.defaultBaseURL)/photos") else {
            fatalError("Invalid PhotosNextPage URL")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
        return nil
    }
    
    func addPhotos(from arr: [PhotoResult]) {
        DispatchQueue.main.async {
            arr.forEach{
                self.photos.append(Photo(
                    id: $0.id,
                    size: CGSize(width: $0.width, height: $0.height),
                    createdAt: self.dateFormatter.date(from: $0.createdAt ?? "") ?? nil,
                    welcomeDescription: $0.description,
                    thumbImageURL: $0.urls.small,
                    largeImageURL: $0.urls.full,
                    isLiked: $0.likedByUser
                ))
            }
            NotificationCenter.default.post(
                name: ImagesListService.didChangeNotification,
                object: nil,
                userInfo: ["photos": self.photos]
            )
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage.shared.token else {
            print("[ImagesListService]", "Отсутствует токен")
            return
        }
        if networkClient.task != nil { return }
        
        let request = makeLikeRequest(token: token, photoId: photoId, isLike: isLike)
        
        guard let request else {
            assertionFailure("Ошибка запроса изменения лайка")
            return
        }
        
        networkClient.objectTask(for: request) { [weak self] (result: Result<LikeResponse, Error>) in
            guard let self else { return }
            switch result {
            case .success(let response):
                let updatedPhoto = updateLike(likePhoto: response.photo)
                if let updatedPhoto {
                    completion(.success(updatedPhoto))
                }
            case .failure(let error):
                print("[ImagesListService]", "Ошибка сетевого запроса", error)
            }
            self.networkClient.task = nil
        }
    }
    
    func makeLikeRequest(token: String, photoId: String, isLike: Bool) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: "\(Constants.defaultBaseURL)/photos/\(photoId)/like") else {
            fatalError("Invalid Photo like URL")
        }
        urlComponents.queryItems = []
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = isLike ? "DELETE" : "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
        return nil
    }
    
    func updateLike(likePhoto: LikePhoto) -> Photo? {
        if let index = self.photos.firstIndex(where: { $0.id == likePhoto.id }) {
            let photo = self.photos[index]
            let newPhoto = Photo(
                id: photo.id,
                size: photo.size,
                createdAt: photo.createdAt,
                welcomeDescription: photo.welcomeDescription,
                thumbImageURL: photo.thumbImageURL,
                largeImageURL: photo.largeImageURL,
                isLiked: likePhoto.likedByUser
            )
            
            self.photos[index] = newPhoto
            return newPhoto
        }
        return nil
    }
}
