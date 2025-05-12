//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Main on 01.05.2025.
//

import Foundation

struct UserResult: Codable {
    let profileImage: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init(){}
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    var networkClient = NetworkClient()
    
    func setAvatar(str: String){
        avatarURL = str
    }
    
    func clear(){
        avatarURL = nil
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if networkClient.task != nil {
            return
        }
        
        guard let request = makeProfileImagRequest(username: username) else { return }
        
        networkClient.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                guard let profileImage = data.profileImage,
                      let smallProfileImage = profileImage["small"] else { return }
                self.avatarURL = smallProfileImage
                completion(.success(smallProfileImage))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": smallProfileImage]
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func makeProfileImagRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            fatalError("Invalid profile URL")
        }
        
        guard let token = OAuth2TokenStorage.shared.token else { return nil }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
     }
}
