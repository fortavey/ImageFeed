//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Main on 10.05.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsUpdateProfileDetails() {
        //given
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        profileViewController.configure(presenter)
        
        //when
        _ = profileViewController.view
        
        //then
        XCTAssertTrue(presenter.viewUpdateProfileDetailsCalled)
    }
    
    func testPresenterCallsLogout() {
        // given
        let logoutService = ProfileLogoutServiceSpy()
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenter(profileLogoutService: logoutService)
        profileViewController.configure(presenter)
        
        // when
        presenter.logout()
        
        //then
        XCTAssertTrue(logoutService.logoutCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(profileLogoutService: ProfileLogoutService())
        let string = "https://google.com"
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.updateAvatar(string: string)
        
        //then
        XCTAssertTrue(viewController.setImageCalled)
    }
    
    func testPresenterNotificationCenterNotNil() {
        // given
        let presenter = ProfilePresenter(profileLogoutService: ProfileLogoutService())
        
        // when
        presenter.setNotificationObserver()
        
        //then
        XCTAssertNotNil(presenter.profileImageServiceObserver)
    }
    
}

