//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Main on 07.05.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        OAuth2TokenStorage.shared.token = nil
        ProfileService.shared.clear()
        ProfileImageService.shared.clear()
        ImagesListService.shared.clear()
        cleanCookies()
        
        print(OAuth2TokenStorage.shared.token)
        
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
    
