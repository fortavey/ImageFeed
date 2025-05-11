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
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

public struct Profile: Decodable {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    var networkClient = NetworkClient()
    private(set) var profile: Profile?
    
    func clear(){
        profile = nil
    }
    
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
    }
}
