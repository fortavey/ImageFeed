//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Main on 10.05.2025.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateProfileDetails()
    func updateAvatar(string: String?)
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    var profileImageServiceObserver: NSObjectProtocol?
    var profileLogoutService: ProfileLogoutServiceProtocol
    
    init(profileLogoutService: ProfileLogoutServiceProtocol) {
        self.profileLogoutService = profileLogoutService
    }
    
    func viewDidLoad() {
        setNotificationObserver()
        updateAvatar(string: ProfileImageService.shared.avatarURL)
    }
    
    func setNotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar(string: ProfileImageService.shared.avatarURL)
            }
    }
    
    func logout() {
        guard let view else { return }
        profileLogoutService.logout(delegate: view as! ProfileLogoutServiceDelegate)
    }
    
    var view: ProfileViewControllerProtocol?
    
    func updateProfileDetails(){
        if let profile = ProfileService.shared.profile {
            guard let view = view else { return }
            view.updateProfileDetails(profile: profile)
        }
    }
    func updateAvatar(string: String?) {
        guard let view, let string, let url = URL(string: string) else { return }
        view.updateAvatar(url: url)
    }
}
