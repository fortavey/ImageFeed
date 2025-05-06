//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Main on 25.04.2025.
//

import Foundation
import SwiftKeychainWrapper

private enum Keys {
    static let accessToken = "access_token"
}

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.accessToken)
        }
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: Keys.accessToken)
            
        }
    }
}
