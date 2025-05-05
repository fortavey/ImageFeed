//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Main on 01.05.2025.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile: Decodable {
    var username: String
    var name: String
    var loginName: String
    var bio: String
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    var networkClient = NetworkClient()
    private(set) var profile: Profile?
    
    
    func makeProfileRequest(token: String) -> URLRequest {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            fatalError("Invalid profile URL")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
     }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if networkClient.task != nil {
            return
        }
        
        let request = makeProfileRequest(token: token)
        
        networkClient.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let data):
                let user = Profile(username: data.username,
                                   name: "\(data.firstName) \(data.lastName ?? "")",
                                   loginName: "@\(data.username)",
                                   bio: data.bio ?? "")
                self.profile = user
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
//        networkClient.fetch(request: request) { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let data):
//                do {
//                    let decoder = JSONDecoder()
//                    let response = try decoder.decode(ProfileResult.self, from: data)
//                    let user = Profile(username: response.username,
//                                       name: "\(response.firstName) \(response.lastName ?? "")",
//                                       loginName: "@\(response.username)",
//                                       bio: response.bio ?? "")
//                    self.profile = user
//                    completion(.success(user))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}
