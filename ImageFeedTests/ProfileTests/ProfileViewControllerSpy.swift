//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Main on 11.05.2025.
//

import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfilePresenterProtocol)?
    var setImageCalled = false
    
    func configure(_ presenter: any ImageFeed.ProfilePresenterProtocol) {
        
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        
    }
    func updateAvatar(url: URL) {
        setImageCalled = true
    }
    
    
    
    
}
