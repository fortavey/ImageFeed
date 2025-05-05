//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Main on 24.04.2025.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

struct OAuthTokenResponseBody: Decodable {
    var access_token: String
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    var lastCode: String?
    
    var networkClient = NetworkClient()
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            fatalError("Invalid OAuth token URL")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            return request
        }
        return nil
     }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if networkClient.task != nil {                                    // 5
            if lastCode != code {                           // 6
                networkClient.task?.cancel()                              // 7
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return                                      // 8
            }
        } else {
            if lastCode == code {                           // 9
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        
        lastCode = code
        
        let request = makeOAuthTokenRequest(code: code)
        
        guard let request else {
            fatalError("Invalid OAuth token request")
        }
        
        networkClient.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.access_token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
