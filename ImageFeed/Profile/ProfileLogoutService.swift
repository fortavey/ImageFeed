//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Main on 07.05.2025.
//

import Foundation
import WebKit

public protocol ProfileLogoutServiceDelegate: AnyObject {
    func navigateAfterLogout()
}
public protocol ProfileLogoutServiceProtocol {
    func logout(delegate: ProfileLogoutServiceDelegate)
}

final class ProfileLogoutService: ProfileLogoutServiceProtocol {
    func logout(delegate: ProfileLogoutServiceDelegate) {
        OAuth2TokenStorage.shared.token = nil
        ProfileService.shared.clear()
        ProfileImageService.shared.clear()
        ImagesListService.shared.clear()
        cleanCookies()
                
        delegate.navigateAfterLogout()
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
    
