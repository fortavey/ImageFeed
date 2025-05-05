//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Main on 24.04.2025.
//

import Foundation

struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }
    
    var task: URLSessionDataTask?
    
    mutating func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data else {
                handler(.failure(NetworkError.codeError))
                return
            }
            handler(.success(data))
        }
        
        if let task {
            task.resume()
        }
    }
    
    mutating func objectTask<T: Decodable>(
            for request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
        ) {
            self.fetch(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(T.self, from: data)
                        completion(.success(response))
                    } catch {
                        print("[NetworkClient]", "Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("[NetworkClient]", "Ошибка сетевого запроса: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
}
