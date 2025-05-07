//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Main on 06.05.2025.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    var id: String
    var width: Double
    var height: Double
    var description: String?
    var urls: UrlsResult
}

struct UrlsResult: Codable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}

final class ImagesListService {
    static let shared = ImagesListService()
    private init(){}
    
    private var networkClient = NetworkClient()
    
    private(set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var currentPage: Int = 0
    
    // ...
    
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
                print("[ImagesListService]", "Ошибка сетевого запроса")
            }
            self.networkClient.task = nil
        }
        
        func addPhotos(from arr: [PhotoResult]) {
            DispatchQueue.main.async {
                arr.forEach{
                    self.photos.append(Photo(
                        id: $0.id,
                        size: CGSize(width: $0.width, height: $0.height),
                        createdAt: nil,
                        welcomeDescription: $0.description,
                        thumbImageURL: $0.urls.small,
                        largeImageURL: $0.urls.full,
                        isLiked: false
                    ))
                }
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: nil,
                    userInfo: ["photos": self.photos]
                )
            }
        }
    }
    
    func makePhotosNextPageRequest(token: String, nextPage: Int) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/photos") else {
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
}
