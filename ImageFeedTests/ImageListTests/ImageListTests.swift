//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Main on 10.05.2025.
//

@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        imagesListViewController.configure(presenter)
        
        //when
        _ = imagesListViewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    func testPresenterNotificationCentreNotNil() {
        // given
        let imagesListHelper = ImagesListHelper()
        let presenter = ImageListPresenter(imagesListHelper: imagesListHelper)
        
        // when
        presenter.viewDidLoad()
        
        //then
        XCTAssertNotNil(presenter.imageListObserver)
    }
    
    func testViewControllerCallsFetchRequest() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        imagesListViewController.configure(presenter)
        
        //when
        _ = imagesListViewController.view
        
        //then
        XCTAssertTrue(presenter.fetchRequestCalled)
    }
    
    func testImageListCellClickLike () {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        imagesListViewController.configure(presenter)
        
        //when
        imagesListViewController.imageListCellClickLike(ImagesListCell())
        
        //then
        XCTAssertTrue(presenter.didSetLikeCallSuccess)
    }
}
