//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Main on 24.04.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    var access_token: String
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    let networkClient = NetworkClient()
    
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
        let request = makeOAuthTokenRequest(code: code)
        
        guard let request else {
            fatalError("Invalid OAuth token request")
        }
        
        networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.access_token))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
