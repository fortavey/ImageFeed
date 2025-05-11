//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Main on 10.05.2025.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    func updateAvatar(string: String?) {
        
    }
    
    func viewDidLoad() {
        
    }
    
    var view: ProfileViewControllerProtocol?
        
    var viewUpdateProfileDetailsCalled: Bool = false
    
    func updateProfileDetails() {
        viewUpdateProfileDetailsCalled = true
    }
    func logout() {
        
    }
}
