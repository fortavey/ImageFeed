//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Main on 25.04.2025.
//

import Foundation

private enum Keys {
    static let accessToken = "access_token"
}

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.accessToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.accessToken)
        }
    }
}
