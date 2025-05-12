//
//  ProfileLogoutServiceSpy.swift
//  ImageFeedTests
//
//  Created by Main on 11.05.2025.
//

import Foundation
import ImageFeed

final class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
    
    static let shared = ProfileLogoutServiceSpy()
    init() { }
    
    var logoutCalled = false
    
    private func cleanCookies() {
        
    }
    
    func logout(delegate: ProfileLogoutServiceDelegate) {
        logoutCalled = true
    }
}
