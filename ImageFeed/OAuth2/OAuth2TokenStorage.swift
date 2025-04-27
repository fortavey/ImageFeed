//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Main on 25.04.2025.
//

import Foundation

class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "access_token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "access_token")
        }
    }
}
